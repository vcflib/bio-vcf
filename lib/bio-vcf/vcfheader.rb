
module BioVcf

  module VcfHeaderParser
    def VcfHeaderParser.get_column_headers(header)
      header.each do | line |
        if line =~ /^#[^#]/
          return line.split[1..-1]
        end
      end
      nil
    end
  end

  class VcfHeader

    attr_reader :lines

    def initialize
      @lines = []
    end

    def add line
      @lines << line.strip
    end

    # Return array of column headers
    def column_header
      @column_header ||= VcfHeaderParser::get_column_headers(@lines)
    end
  end

end
