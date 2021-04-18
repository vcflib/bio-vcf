# This module parses the VCF header. A header consists of lines
# containing fields. Most fields are of 'key=value' type and appear
# only once.  These can be retrieved with the find_field method.
#
# INFO, FORMAT and contig fields are special as they appear multiple times
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

    def VcfHeaderParser.parse_field(line, debug)
      BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(line, debug: debug)
    end
  end

  class VcfHeader

    attr_reader :lines, :field

    def initialize(debug = false)
      @debug = debug
      @lines = []
      @field = {}
      @meta = nil
      @cached_filter_index = {}
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

    # Returns the field number for a sample (starting with 9)
    def sample_index
      return @sample_index if @sample_index
      index = {}
      samples.each_with_index { |k,i| index[k] = i+9 ; index[k.downcase] = i+9 }
      @sample_index = index
      index
    end

    # Give a list of samples (by index and/or name) and return 0-based index values
    # The cache has to be able to hanle multiple lists - that is why it is a hash.
    def sample_subset_index list
      cached = @cached_filter_index[list]
      if cached
        l = cached
      else
        l = []
        list = samples_index_array() if not list
        list.each { |i|
          value =
            begin
              Integer(i)
            rescue
              idx = samples.index(i)
              if idx != nil
                idx
              else
                raise "Unknown sample name '#{i}'"
              end
            end
          l << value
        }
        @cached_filter_index[list] = l
      end
      l
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
          v = VcfHeaderParser.parse_field(line,@debug)
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

    def filter
      find_fields('FILTER')
    end

    def contig
      find_fields('contig')
    end

    def info
      find_fields('INFO')
    end

    def gatkcommandline
      find_fields('GATKCommandLine')
    end

    def meta
      return @meta if @meta
      res = { 'INFO' => {}, 'FORMAT' => {}, 'FILTER' => {}, 'contig' => {}, 'GATKCommandLine' => {} }
      @lines.each do | line |
        value = line.scan(/##(.*?)=(.*)/)
        if value[0]
          k,v = value[0]
          if k != 'FORMAT' and k != 'INFO' and k != 'FILTER' and k != 'contig' and k != 'GATKCommandLine'
            # p [k,v]
            res[k] = v
          end
        end
      end
      res['INFO'] = info()
      res['FORMAT'] = format()
      res['FILTER'] = filter()
      res['contig'] = contig()
      res['GATKCommandLine'] = gatkcommandline()
      # p [:res, res]
      @meta = res # cache values
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
