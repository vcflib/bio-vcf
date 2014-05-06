module BioVcf
  module VcfLine

    # Split a line into fields and check size
    def VcfLine.parse line,expected_size=nil
      fields = line.strip.split(/\t/)
      raise "Unexpected line #{line}" if line.strip.size == 0 or fields.size < 6
      raise "Expected #{expected_size} fields but got #{fields.size} in "+fields.to_s if expected_size and fields.size != expected_size
      fields
    end
  end
end
