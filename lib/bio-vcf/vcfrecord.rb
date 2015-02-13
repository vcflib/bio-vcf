module BioVcf

  class VcfRecordInfo 
    def initialize s
      @info = s
    end

    def to_s
      if @h
        @h.map { |k,v| (v ? @original_key[k] + '=' + v : @original_key[k])  }.join(';')
      else
        @info
      end
    end

    def [] k
      # split_fields if not @h
      # /#{m}=(?<value>[^;])/.@info
      kup = k.upcase
      v = if @h
            @h[kup]
          else
            @info =~ /#{k}=([^;]+)/i
            value = $1
            # p [m,value]
            # m = @info.match(/#{m.to_s.upcase}=(?<value>[^;]+)/) slower!
            # value = m[:value]
            if value == nil
              split_fields # no option but to split
              @h[kup]
            else
              value
            end
          end
      ConvertStringToValue::convert(v)
    end
    
    # Set INFO fields (used by --rewrite)
    def []= k, v   
      split_fields if not @h
      kupper = k.upcase
      @h[kupper] = v
      @original_key[kupper] = k
    end
    
    def method_missing(m, *args, &block)
      self[m.to_s]
    end  

  private
 
    def split_fields
      @h = {}
      @original_key = {}
      @info.split(/;/).each do |f| 
        k,v = f.split(/=/) 
        kupper = k.upcase
        @h[kupper] = v
        @original_key[kupper] = k
      end
    end
  end

  module VcfRecordParser
    # Parse the format field into a Hash
    def VcfRecordParser.get_format s
      if s==$cached_sample_format_s
        $cached_sample_format
      else
        h = {}
        s.split(/:/).each_with_index { |v,i| h[v] = i }
        $cached_sample_format = h
        $cached_sample_format_s = s
        h
      end
    end
    def VcfRecordParser.get_info s
      VcfRecordInfo.new(s)
    end
  end

  module VcfRecordCall
    def call_diff
      Variant.diff(normal.bcount.to_ary,tumor.bcount.to_ary)
    end

    def call_nuc
      ['A','C','G','T'][index()]
    end

    # Get the GT when 0 is REF and >0 is ALT
    def get_gt(index)
      if index == 0
        ref()
      else
        alt[index-1]
      end
    end

    def call_tumor_count
      tumor.bcount.to_ary[index()]
    end

    def call_tumor_relative_count
      Variant.relative_diff(normal.bcount.to_ary,tumor.bcount.to_ary)[index()]
    end

    def call_normal_count
      normal.bcount.to_ary[index()]
    end

    def index
      Variant.index(self.normal.bcount.to_ary,self.tumor.bcount.to_ary)
    end
  end

  class VcfRecord

    include VcfRecordCall

    attr_reader :header

    def initialize fields, header
      @fields = fields
      @header = header
      @sample_by_index = []
    end

    def chrom
      @fields[0]
    end

    alias :chr :chrom

    def pos
      @pos ||= @fields[1].to_i
    end

    def ids 
      @ids ||= @fields[2].split(';')
    end

    def id
      ids[0]
    end

    def ref
      @refs ||= @fields[3]
    end

    def alt
      @alt ||= @fields[4].split(/,/)
    end

    def qual
      @qual ||= @fields[5].to_f
    end

    def info
      @info ||= VcfRecordParser.get_info(@fields[7])
    end

    def format
      @format ||= VcfRecordParser.get_format(@fields[8])
    end

    # Return the first (single) sample (used in one sample VCF)
    def first
      @first ||= VcfGenotypeField.new(@fields[9],format,@header,ref,alt)
    end

    # Return the normal sample (used in two sample VCF)
    def normal
      first
    end

    # Return the tumor sample (used in two sample VCF)
    def tumor
      @tumor ||= VcfGenotypeField.new(@fields[10],format,@header,ref,alt)
    end
   
    # Return the sample as a named hash 
    def sample 
      @sample ||= VcfGenotypeFields.new(@fields,format,@header,ref,alt)
    end

    def sample_by_name name
      sample[name]
    end

    def sample_by_index i
      # p @fields
      raise "Can not index sample on parameter <#{i}>" if not i.kind_of?(Integer)
      @sample_by_index[i] ||= VcfGenotypeField.new(@fields[i+9],format,@header,ref,alt)
    end

    # Walk the samples. list contains an Array of int (the index)
    def each_sample(list = nil)
      list = @header.samples_index_array() if not list 
      list.each { |i| yield VcfSample::Sample.new(self,sample_by_index(i.to_i)) }
    end

    def missing_samples?
      @fields[9..-1].each { |sample|
        return true if VcfSample::empty?(sample)
      }
      false
    end

    def valid?
      @fields.size == @header.column_names.size
    end

    def eval expr, ignore_missing_data: true, quiet: false
      begin
        if not respond_to?(:call_cached_eval)
          code =
          """
          def call_cached_eval(rec,fields)
            r = rec
            #{expr}
          end
          """
          self.class.class_eval(code)
        end
        res = call_cached_eval(self,@fields)
        if res.kind_of?(Array)
          res.join("\t")
        else
          res
        end
      rescue NoMethodError => e
        if not quiet
          $stderr.print "RECORD ERROR!\n"
          $stderr.print [@fields],"\n"
          $stderr.print expr,"\n"
        end
        if ignore_missing_data
          $stderr.print e.message if not quiet
          return false
        else
          raise
        end
      end
    end

    def filter expr, ignore_missing_data: true, quiet: false
      begin
        if not respond_to?(:call_cached_filter)
          code =
          """
          def call_cached_filter(rec,fields)
            r = rec
            #{expr}
          end
          """
          self.class.class_eval(code)
        end
        res = call_cached_filter(self,@fields)
        if res.kind_of?(Array)
          res.join("\t")
        else
          res
        end
      rescue NoMethodError => e
        if not quiet
          $stderr.print "RECORD ERROR!\n"
          $stderr.print [@fields],"\n"
          $stderr.print expr,"\n"
        end
        if ignore_missing_data
          $stderr.print e.message if not quiet
          return false
        else
          raise
        end
      end
    end

    # Return the sample
    def method_missing(m, *args, &block)  
      name = m.to_s
      if name =~ /\?$/
        # Query for empty sample name
        @sample_index ||= @header.sample_index
        return !VcfSample::empty?(@fields[@sample_index[name.chop]])
      else
        sample[name]
      end
    end  

  end
end
