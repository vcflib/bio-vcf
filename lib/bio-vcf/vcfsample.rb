module BioVcf
  module VcfSample

  # Check whether a sample is empty (on the raw string value)
  def VcfSample::empty? raw_sample
    s = raw_sample.strip
    s == './.' or s == ''
  end

  class Record
    # #<BioVcf::VcfGenotypeField:0x00000001a0c188 @values=["0/0", "151,8", "159", "99", "0,195,2282"], @format={"GT"=>0, "AD"=>1, "DP"=>2, "GQ"=>3, "PL"=>4}, 
    def initialize sample
      @rec = sample
      @format = @rec.format
      @values = @rec.values
    end

    def eval expr, ignore_missing_data, quiet
      begin
        s = sample = self
        Kernel::eval(expr)
      rescue Exception => e
        if not quiet
          $stderr.print "ERROR!\n"
          $stderr.print [@format,@values],"\n"
          $stderr.print expr,"\n"
        end
        if ignore_missing_data and not quiet
          $stderr.print e.message
          return false
        else
          raise
        end
      end
    end

    def integer?(str)
      !!Integer(str) rescue false
    end

    def method_missing(m, *args, &block)  
      v = @values[@format[m.to_s.upcase]]  # <-- save on the upcase!
      if integer?(v)  # the common case
        v = v.to_i
      else
        v = v.to_f if v =~ /^\d+\.\d+$/
      end
      v
    end  

  end


  end
end
