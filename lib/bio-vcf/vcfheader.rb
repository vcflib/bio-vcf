# This module parses the VCF header. A header consists of lines
# containing fields. Most fields are of 'key=value' type and appear
# only once.  These can be retrieved with the find_field method.
#
# INFO and FORMAT fields are special as they appear multiple times
# and contain multiple key values (identified by an ID field).
# To retrieve these call 'info' and 'format' functions respectively,
# which return a hash on the contained ID.
#
# For the INFO and FORMAT fields a Ragel parser is used, mostly to
# deal with embedded quoted fields.

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

    def VcfHeaderParser.parse_field(line)
      BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(line, debug: false)
    end
  end

  class VcfHeader

    attr_reader :lines, :field

    def initialize
      @lines = []
      @field = {}
    end

    # Add a new field to the header
    def add line
      @lines += line.split(/\n/)
    end

    # Push a special key value list to the header
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

    # Look for a line in the header with the field name and return the
    # value, otherwise return nil
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

    # Look for all the lines that match the field name and return
    # a hash of hashes. An empty hash is returned when there are
    # no matches.
    def find_fields name
      res = {}
      @lines.each do | line |
        value = line.scan(/###{name}=<(.*)>/)
        if value[0]
          str = value[0][0]
          # p str
          v = VcfHeaderParser.parse_field(line)
          id = v['ID']
          res[id] = v
        end
      end
      # p res
      res
    end

    def format 
      find_fields('FORMAT')
    end

    def info
      find_fields('INFO')
    end

    def meta
      res = { 'INFO' => {}, 'FORMAT' => {} }
      @lines.each do | line |
        value = line.scan(/##(.*?)=(.*)/)
        if value[0]
          k,v = value[0]
          if k != 'FORMAT' and k != 'INFO'
            # p [k,v]
            res[k] = v
          end
        end
      end
      res['INFO'] = info
      res['FORMAT'] = format
      # p [:res, res]
      res
    end
    
    def method_missing(m, *args, &block)
      name = m.to_s
      value = find_field(name)
      return value if value
      raise "Unknown VCF header query '#{name}'"
    end

  end
end
