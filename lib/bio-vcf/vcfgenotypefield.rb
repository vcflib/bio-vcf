module BioVcf

  MAXINT=100_000

  class ValueError < Exception
  end

  module VcfValue
    def VcfValue::empty? v
      v == nil or v == '' or v == '.'
    end
  end

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

    def initialize s, format, header, ref, alt
      @is_empty = VcfSample::empty?(s)
      @original_s = s
      @format = format
      @header = header
      @ref = ref
      @alt = alt
    end

    def to_s
      @original_s
    end

    def values
      @cache_values ||= @original_s.split(/:/)
    end

    def empty?
      @is_empty
    end

    def valid?
      !empty?
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
      VcfNucleotideCount4.new(@alt,values[fetch('BCOUNT')])
    end

    def bq
      VcfAltInfoList.new(@alt,values[fetch('BQ')])
    end

    def amq
      VcfAltInfoList.new(@alt,values[fetch('AMQ')])
    end

    def gti?
      not VcfValue::empty?(fetch_value("GT"))
    end

    def gti
      gt.split('/').map { |g| g.to_i }
    end

    def gts?
      not VcfValue::empty?(fetch_value("GT"))
    end

    def gts
      genotypes = [@ref] + @alt
      gti.map { |i| genotypes[i] }
    end

    # Returns the value of a field
    def method_missing(m, *args, &block)
      return nil if @is_empty
      if m =~ /\?$/
        # query if a value exists, e.g., r.info.dp? or s.dp?
        v = values[fetch(m.to_s.upcase.chop)]
        return (not VcfValue::empty?(v))
      else
        v = values[fetch(m.to_s.upcase)]
        return nil if VcfValue::empty?(v)
        v = v.to_i if v =~ /^\d+$/
        v = v.to_f if v =~ /^\d+\.\d+$/
        v
      end
    end  

  private

    # Fetch a value and throw an error if it does not exist
    def fetch name
      raise "ERROR: Field with name #{name} does not exist!" if !@format[name]
      @format[name]
    end

    def fetch_value name
      values[fetch(name)]
    end

    # Return an integer list
    def ilist name
      v = fetch_value(name)
      return nil if not v
      v.split(',').map{|i| i.to_i} 
    end

  end

  # Holds all samples
  class VcfGenotypeFields
    def initialize fields, format, header, ref, alt
      @fields = fields
      @format = format
      @header = header
      @ref = ref
      @alt = alt
      @samples = {} # lazy cache
      @sample_index = @header.sample_index()
    end

    def [] name
      @samples[name] ||= VcfGenotypeField.new(@fields[@sample_index[name]],@format,@header,@ref,@alt)
    end

    def method_missing(m, *args, &block) 
      name = m.to_s
      if name =~ /\?$/
        # test for valid sample
        return !VcfSample::empty?(@fields[@sample_index[name.chop]])
      else
        @samples[name] ||= VcfGenotypeField.new(@fields[@sample_index[name]],@format,@header,@ref,@alt)
      end
    end  

  end
end
