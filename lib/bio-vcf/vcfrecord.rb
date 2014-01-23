module BioVcf

  module VcfRecordParser
    def VcfRecordParser.get_format s
      h = {}
      s.split(/:/).each_with_index { |v,i| h[v] = i }
      h
    end
  end

  class VcfRecord

    def initialize fields, header
      @header = header
      @fields = fields
    end
     
    def chrom
      @fields[0]
    end

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
      @alt ||= @fields[4]
    end

    def format
      @format ||= VcfRecordParser.get_format(@fields[8])
    end

    def normal
      @normal ||= VcfGenotypeField.new(@fields[9],format,@header)
    end

    def tumor
      @tumor ||= VcfGenotypeField.new(@fields[10],format,@header)
    end

  end
end
