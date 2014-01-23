module BioVcf
  module VcfLine
    def VcfLine.parse line,expect_size
      fields = line.strip.split(/\t/)
      raise "Expected #{expect_size} fields but got #{fields.size} in "+fields.to_s if fields.size != expect_size
      fields
    end
  end
end
