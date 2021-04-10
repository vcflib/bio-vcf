require 'erb'

module Bio

  class Template

    def initialize fn, handle_comma=false
      @handle_comma = handle_comma
      raise "Can not find template #{fn}!" if not File.exist?(fn)
      parse(File.read(fn))
      @is_first = true
    end

    # Parse the template and split into HEADER, BODY and FOOTER sections
    def parse buf
      header = []
      body = []
      footer = []
      where = :header
      buf.split("\n").each do | line |
        case where
          when :header
            next if line =~ /=HEADER/
            if line =~ /=BODY/
              body = []
              where = :body
              next
            end
            header << line
          when :body
            if line =~ /=FOOTER/
              footer = []
              where = :footer
              next
            end
            body << line
          else
            footer << line
        end
      end
      if body == []
        body = header
        header = []
      end
      @erb_header = ERB.new(header.join("\n")) if header.size
      body2 = body.join("\n").reverse
      # if there is a comma at the end, eat it
      if @handle_comma
        body2.chars.each_with_index { |c,i|
          break if [']','}'].include?(c)
          if c == ','
            body2[i] = " "
            break
          end
        }
      end
      @erb_body   = ERB.new(body2.reverse) if body.size
      @erb_footer = ERB.new(footer.join("\n")) if footer.size
    end

    def result env
      @erb.result(env)
    end

    # Call the HEADER template (once)
    def header env
      if @erb_header
        @erb_header.result(env)
      else
        ""
      end
    end

    # For every record call the BODY template
    def body env
      if @erb_body
        res =
          if @handle_comma and not @is_first
            ","
          else
            ""
          end
        @is_first = false
        res + @erb_body.result(env)
      else
        ""
      end
    end

    # Call the FOOTER template (once)
    def footer env
      if @erb_footer
        @erb_footer.result(env)
      else
        ""
      end
    end
  end
end
