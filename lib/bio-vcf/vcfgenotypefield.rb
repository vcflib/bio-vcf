module BioVcf

  # Helper class for a list of (variant) values, such as A,G. 
  # The [] function does the hard work (see ./features for examples)
  class VcfNucleotides 
    def initialize alt,list
      @alt = alt
      @list = list.map{|i| i.to_i}
    end
  
    def [] idx
      if idx.kind_of?(Integer)
        @list[idx].to_i
      elsif idx.kind_of?(String)
        @list[["A","C","G","T"].index(idx)].to_i
      else idx.kind_of?(Array)
        idx.map { |nuc|
          idx2 = ["A","C","G","T"].index(nuc)
          # p [idx,nuc,idx2,@list]
          @list[idx2].to_i
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

    def sum list = @alt
      values = self[list]
      values.reduce(0){ |memo,v| v+memo }
    end


  end

  class VcfAltInfo
    def initialize alt,list
      @alt = alt
      @list = list.map{|i| i.to_i}
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

  end


  class VcfGenotypeField
    def initialize s, format, header, alt
      @values = s.split(/:/)
      @format = format
      @header = header
      @alt = alt
    end

    def dp4
      @values[@format['DP4']].split(',').map{|i| i.to_i}
    end

    def bcount
      VcfNucleotides.new(@alt,@values[@format['BCOUNT']].split(','))
    end

    def bq
      VcfAltInfo.new(@alt,@values[@format['BQ']].split(','))
    end

    def amq
      VcfAltInfo.new(@alt,@values[@format['AMQ']].split(','))
    end

    def method_missing(m, *args, &block)  
      v = @values[@format[m.to_s.upcase]]
      v = v.to_i if v =~ /^\d+$/
      v = v.to_f if v =~ /^\d+\.\d+$/
      v
    end  

  end
end
