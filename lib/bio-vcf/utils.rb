module BioVcf

  module ConvertStringToValue
    def self::integer?(str)
      !!Integer(str) rescue false
    end

    def self::float?(str)
      !!Float(str) rescue false
    end

    def self::convert str
      if integer?(str)
        str.to_i 
      else
        str.to_f if float?(str)
      end
    end
  end

end
