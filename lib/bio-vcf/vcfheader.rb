
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

    attr_reader :lines, :field

    def initialize
      @lines = []
      @field = {}
    end

    def add line
      @lines = line.split(/\n/)
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
      @samples ||= if column_names.size > 8
                     column_names[9..-1]
                   else
                     []
                   end
    end

    def samples_index_array
      @all_samples_index ||= column_names[9..-1].fill{|i| i}
    end

    def num_samples
      @num_samples ||= ( samples == nil ? 0 : samples.size )
    end

    def sample_index
      return @sample_index if @sample_index
      index = {}
      samples.each_with_index { |k,i| index[k] = i+9 ; index[k.downcase] = i+9 }
      @sample_index = index
      index
    end

    def find_field name
      return field[name] if field[name]
      @lines.each do | line |
        value = line.scan(/###{name}=(.*)/)
        if value[0]
          v = value[0][0]
          field[name] = v
          return v
        end
      end
      nil
    end
    
    def method_missing(m, *args, &block)
      name = m.to_s
      value = find_field(name)
      return value if value
      raise "Unknown VCF header query '#{name}'"
    end


  end

end
