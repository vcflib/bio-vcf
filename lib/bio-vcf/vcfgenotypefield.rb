module BioVcf

  MAXINT=100_000

  # Helper class for a list of (variant) values, such as A,G. 
  # The [] function does the hard work. You can pass in an index (integer)
  # or nucleotide which translates to an index.
  # (see ./features for examples)
  class VcfNucleotideCount4
    def initialize alt,list
      @alt = alt
      @list = list.split(/,/).map{|i| i.to_i}
    end
  
    def [] idx
      if idx.kind_of?(Integer)
        # return a value
        @list[idx]
      elsif idx.kind_of?(String)
        # return a value
        @list[["A","C","G","T"].index(idx)]
      else idx.kind_of?(Array)
        # return a list of values
        idx.map { |nuc|
          idx2 = ["A","C","G","T"].index(nuc)
          # p [idx,nuc,idx2,@list]
          @list[idx2]
        }
      end
    end

    def to_ary
      @list
    end

    # Return the max value on the nucleotides in the list (typically rec.alt)
    def max list = @alt
      values = self[list]
      values.reduce(0){ |memo,v| (v>memo ? v : memo) }
    end

    def min list = @alt
      values = self[list]
      values.reduce(MAXINT){ |memo,v| (v<memo ? v : memo) }
    end

    def sum list = @alt
      values = self[list]
      values.reduce(0){ |memo,v| v+memo }
    end


  end

  # Handle info fields with multiple entries, possibly relating to ALT (single nucleotide only)
  class VcfAltInfoList
    def initialize alt,list
      @alt = alt
      @list = list.split(/,/).map{|i| i.to_i}
    end
  
    def [] idx
      if idx.kind_of?(Integer)
        @list[idx].to_i
      elsif idx.kind_of?(String)
        @list[@alt.index(idx)].to_i
      else idx.kind_of?(Array)
        idx.map { |nuc|
          idx2 = @alt.index(nuc)
          # p [idx,nuc,idx2,@list]
          @list[idx2].to_i
        }
      end
    end

    def to_ary
      @list
    end

    # Return the max value on the nucleotides in the list (typically rec.alt)
    def max 
      @list.reduce(0){ |memo,v| (v>memo ? v : memo) }
    end

    def min 
      @list.reduce(MAXINT){ |memo,v| (v<memo ? v : memo) }
    end

    def sum 
      @list.reduce(0){ |memo,v| v+memo }
    end
  end

  class VcfGenotypeField

    attr_reader :format, :values, :header

    def initialize s, format, header, alt
      @is_empty = (s == '' or s == nil or s == './.')
      @values = s.split(/:/)
      @format = format
      @header = header
      @alt = alt
    end

    def empty?
      @is_empty
    end

    def valid?
      !@is_empty
    end

    def dp4 
      ilist('DP4') 
    end
    def ad 
      ilist('AD') 
    end
    def pl 
      ilist('PL') 
    end

    def bcount
      VcfNucleotideCount4.new(@alt,@values[fetch('BCOUNT')])
    end

    def bq
      VcfAltInfoList.new(@alt,@values[fetch('BQ')])
    end

    def amq
      VcfAltInfoList.new(@alt,@values[fetch('AMQ')])
    end

    def method_missing(m, *args, &block)
      return nil if @is_empty
      if m =~ /\?$/
        # query if a value exists, e.g., r.info.dp?
        v = @values[fetch(m.to_s.upcase.chop)]
        v != nil
      else
        v = @values[fetch(m.to_s.upcase)]
        v = v.to_i if v =~ /^\d+$/
        v = v.to_f if v =~ /^\d+\.\d+$/
        v
      end
    end  

  private

    def fetch name
      raise "ERROR: Field with name #{name} does not exist!" if !@format[name]
      @format[name]
    end

    def ilist name
      v = @values[fetch(name)]
      return nil if not v
      v.split(',').map{|i| i.to_i} 
    end


  end

  # Holds all samples
  class VcfGenotypeFields
    def initialize fields, format, header, alt
      @fields = fields
      @format = format
      @header = header
      @alt = alt
      @samples = {} # lazy cache
      @sample_index = @header.sample_index()
    end

    def [] name
      @samples[name] ||= VcfGenotypeField.new(@fields[@sample_index[name]],@format,@header,@alt)
    end

    def method_missing(m, *args, &block) 
      name = m.to_s
      if name =~ /\?$/
        # test for valid sample
        return !VcfSample::empty?(@fields[@sample_index[name.chop]])
      else
        @samples[name] ||= VcfGenotypeField.new(@fields[@sample_index[name]],@format,@header,@alt)
      end
    end  

  end
end
