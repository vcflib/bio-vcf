module BioVcf

  class VcfGenotypeField
    def initialize s, format, header
      @values = s.split(/:/)
      @format = format
      @header = header
    end

    def method_missing(m, *args, &block)  
      v = @values[@format[m.to_s.upcase]]
      v = v.to_i if v =~ /^\d+$/
      v = v.to_f if v =~ /^\d+\.\d+$/
      v
    end  

  end
end
