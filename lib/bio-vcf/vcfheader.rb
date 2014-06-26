
module BioVcf

  module VcfHeaderParser
    def VcfHeaderParser.get_column_names(lines)
      lines.each do | line |
        if line =~ /^#[^#]/
          # the first line that starts with a single hash 
          names = line.split
          names[0].sub!(/^#/,'')
          return names
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

    # Add a key value list to the header
    def tag h
      h2 = h.dup
      [:show_help,:skip_header,:verbose,:quiet,:debug].each { |key| h2.delete(key) }
      info = h2.map { |k,v| k.to_s.capitalize+'='+'"'+v.to_s+'"' }.join(',')
      line = '##BioVcf=<'+info+'>'
      @lines.insert(-2,line)
      line
    end

    def version
      @version ||= lines[0].scan(/##fileformat=VCFv(\d+\.\d+)/)[0][0]
    end

    def column_names
      @column_names ||= VcfHeaderParser::get_column_names(@lines)
    end

    def columns
      @column ||= column_names.size
    end

    def printable_header_line(fields)
      fields.map { | field |
        if field == '#samples'
          samples
        else
          field
        end
      }.join("\t")
    end

    def samples
      @samples ||= column_names[9..-1]
    end

    def samples_index_array
      @all_samples_index ||= column_names[9..-1].fill{|i| i}
    end

    def sample_index
      return @sample_index if @sample_index
      index = {}
      samples.each_with_index { |k,i| index[k] = i+9 ; index[k.downcase] = i+9 }
      @sample_index = index
      index
    end
  end

end
