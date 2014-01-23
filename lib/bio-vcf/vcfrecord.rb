module BioVcf
  class VcfRecord

    def initialize fields, header
      @header = header
      @fields = fields
    end
     
    def chrom
      @fields[0]
    end

    def pos
      @fields[1].to_i
    end
  end
end
