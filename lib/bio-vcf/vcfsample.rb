module BioVcf
  module VcfSample

  # Check whether a sample is empty (on the raw string value)
  def VcfSample::empty? raw_sample
    s = raw_sample.strip
    s == './.' or s == ''
  end

  class Sample
    # #<BioVcf::VcfGenotypeField:0x00000001a0c188 @values=["0/0", "151,8", "159", "99", "0,195,2282"], @format={"GT"=>0, "AD"=>1, "DP"=>2, "GQ"=>3, "PL"=>4}, 
    def initialize rec,sample
      @rec = rec
      @sample = sample
      @format = @sample.format
      @values = @sample.values
    end

    def eval expr, ignore_missing_data, quiet
      begin
        rec = @rec.dup
        r = rec
        s = sample = self
        Kernel::eval(expr)
      rescue NoMethodError => e
        if not quiet
          $stderr.print "\nSAMPLE ERROR!\n"
          $stderr.print [@format,@values],"\n"
          $stderr.print expr,"\n"
        end
        if ignore_missing_data
          $stderr.print e.message if not quiet
          return false
        else
          raise
        end
      end
    end

    def method_missing(m, *args, &block)  
      v = @values[@format[m.to_s.upcase]]  # <-- save on the upcase!
      ConvertStringToValue::convert(v)
    end  

  end


  end
end
