module BioVcf

  class VcfNucleotides 
    def initialize list
      @list = list
    end
  
    def [] idx
      idx = ["A","C","G","T"].index(idx) if idx.kind_of?(String)
      return 0 if idx == nil
      @list[idx].to_i
    end
  end

  class VcfGenotypeField
    def initialize s, format, header
      @values = s.split(/:/)
      @format = format
      @header = header
    end

    def bcount
      VcfNucleotides.new(@values[@format['BCOUNT']].split(','))
    end

    def bq
      VcfNucleotides.new(@values[@format['BQ']].split(','))
    end

    def amq
      VcfNucleotides.new(@values[@format['AMQ']].split(','))
    end


    def method_missing(m, *args, &block)  
      v = @values[@format[m.to_s.upcase]]
      v = v.to_i if v =~ /^\d+$/
      v = v.to_f if v =~ /^\d+\.\d+$/
      v
    end  

  end
end
