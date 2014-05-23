module BioVcf
  module VcfSample

  # Check whether a sample is empty (on the raw string value)
  def VcfSample::empty? raw_sample
    s = raw_sample.strip
    s == './.' or s == '' or s == nil
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
        empty = VcfSample::empty?(@sample.values.to_s)
        $stderr.print "\nTrying to evaluate on an empty sample #{@sample.values.to_s}!\n" if not empty
        if not quiet
          $stderr.print [@format,@values],"\n"
          $stderr.print expr,"\n"
        end
        if ignore_missing_data
          $stderr.print e.message if not quiet and not empty
          return false
        else
          raise
        end
      end
    end

    # Split GT into index values
    def gti
      v = fetch_values("GT")
      v.split(/\//).map{ |v| (v=='.' ? nil : v.to_i) }
    end

    # Split GT into into a nucleode sequence
    def gts
      gti.map { |i| (i ? @rec.get_gt(i) : nil) }
    end

    def method_missing(m, *args, &block)
      name = m.to_s.upcase
      ConvertStringToValue::convert(fetch_values(name))
    end  

private

    def fetch_values name
      n = @format[name]
      raise "Unknown sample field <#{name}>" if not n
      @values[n]  # <-- save on the upcase!
    end

  end


  end
end
