module BioVcf

  class VcfRecordInfo
    def initialize s
      h = {}
      s.split(/;/).each { |f| k,v=f.split(/=/) ; h[k.upcase] = v }
      @h = h
    end
    def method_missing(m, *args, &block)  
      v = @h[m.to_s.upcase]
      v = v.to_i if v =~ /^\d+$/
      v = v.to_f if v =~ /^\d+\.\d+$/
      v
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
  end
end
