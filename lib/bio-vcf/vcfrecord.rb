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

    # Set INFO fields (used by --rewrite)
    def []= k, v   
      split_fields
      kupper = k.upcase
      @h[kupper] = v
      @original_key[kupper] = k
    end

    def method_missing(m, *args, &block)
      split_fields if not @h
      v = @h[m.to_s.upcase]
      ConvertStringToValue::convert(v)
    end  

  private
 
    def split_fields
      @h = {}
      @original_key = {}
      @info.split(/;/).each do |f| 
        k,v = f.split(/=/) 
        # self[k] = v 
        kupper = k.upcase
        @h[kupper] = v
        @original_key[kupper] = k
      end
    end
  end

  module VcfRecordParser
    # Parse the format field into a Hash
    def VcfRecordParser.get_format s
      h = {}
      s.split(/:/).each_with_index { |v,i| h[v] = i }
      h
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

    # Return the normal sample (used in two sample VCF)
    def normal
      @normal ||= VcfGenotypeField.new(@fields[9],format,@header,alt)
    end

    # Return the tumor sample (used in two sample VCF)
    def tumor
      @tumor ||= VcfGenotypeField.new(@fields[10],format,@header,alt)
    end
   
    # Return the sample as a named hash 
    def sample 
      @sample ||= VcfGenotypeFields.new(@fields,format,@header,alt)
    end

    def sample_by_name name
      sample[name]
    end

    def each_sample(list = nil)
      samples = @header.column_names[9..-1]
      raise "Empty sample list, can not execute query!" if not samples
      samples.each_with_index { |name,i|
        # p [i,list]
        next if list and not list.index(i.to_s)
        yield VcfSample::Sample.new(self,sample[name]) 
      }
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

    def eval expr, ignore_missing_data, quiet
      begin
        r = rec = self
        fields = @fields
        res = Kernel::eval(expr) 
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
