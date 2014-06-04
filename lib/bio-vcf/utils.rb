module BioVcf

  module ConvertStringToValue
    def self::integer?(str)
      !!Integer(str) rescue false
    end

    def self::float?(str)
      !!Float(str) rescue false
    end

    def self::convert str
      if str =~ /,/
        str.split(/,/)
      else
        if integer?(str)
          str.to_i 
        else
          if float?(str)
            str.to_f 
          else
            str
          end
        end
      end
    end
  end

end
