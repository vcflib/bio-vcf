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

    def eval expr, ignore_missing_data
      begin
        s = sample = self
        Kernel::eval(expr)
      rescue Exception => e
        $stderr.print [@format,@values],"\n"
        $stderr.print expr,"\n"
        $stderr.print e.message
        if ignore_missing_data
          return false
        else
          exit 1 
        end
      end
    end

    def method_missing(m, *args, &block)  
      v = @values[@format[m.to_s.upcase]]
      v = v.to_i if v =~ /^\d+$/
      v = v.to_f if v =~ /^\d+\.\d+$/
      v
    end  

  end


  end
end
