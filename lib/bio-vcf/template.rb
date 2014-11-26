require 'erb'

module Bio

  class Template
    
    def initialize fn
      raise "Can not find template #{fn}!" if not File.exist?(fn)
      parse(File.read(fn))
    end

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
      @erb_body   = ERB.new(body.join("\n")) if body.size
      @erb_footer = ERB.new(footer.join("\n")) if footer.size
    end
    
    def result env
      @erb.result(env)
    end

    def header env
      if @erb_header
        @erb_header.result(env)
      else
        ""
      end
    end

    def body env
      if @erb_body
        @erb_body.result(env)
      else
        ""
      end
    end

    def footer env
      if @erb_footer
        @erb_footer.result(env)
      else
        ""
      end
    end
  end
end
