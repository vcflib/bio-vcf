module BioVcf
  module VcfSample

    # Check whether a sample is empty (on the raw string value)
    def VcfSample::empty? s
      s == './.' or s == '' or s == nil
    end

    class Sample
      # Initialized sample with rec and genotypefield
      #
      # #<BioVcf::VcfGenotypeField:0x00000001a0c188 @values=["0/0", "151,8", "159", "99", "0,195,2282"], @format={"GT"=>0, "AD"=>1, "DP"=>2, "GQ"=>3, "PL"=>4}, 
      def initialize rec,genotypefield
        @rec = rec
        @sample = genotypefield
        @format = @sample.format
        @values = @sample.values
      end

      def empty?
       cache_empty ||= VcfSample::empty?(@sample.to_s)
      end

      def eval expr, ignore_missing_data: false, quiet: false, do_cache: true
        caching_eval :eval, :call_cached_eval, expr, ignore_missing_data: ignore_missing_data, quiet: quiet, do_cache: do_cache
      end

      def sfilter expr, ignore_missing_data: false, quiet: true, do_cache: true
        begin
          if do_cache
            if not respond_to?(:call_cached_sfilter)
              code = 
              """
              def call_cached_sfilter(rec,sample)
                r = rec
                s = sample 
                #{expr}
              end
              """
              self.class.class_eval(code)
            end
            call_cached_sfilter(@rec,self)
          else 
            print "WARNING: NOT CACHING EVAL\n"
            self.class.class_eval { undef :call_cached_eval } if respond_to?(:call_cached_eval)
            # Without cache for testing 
            r = @rec
            s = @sample
            eval(expr)
          end
        rescue NoMethodError => e
          $stderr.print "\nTrying to evaluate on an empty sample #{@sample.values.to_s}!\n" if not empty? and not quiet
          if not quiet
            $stderr.print [@format,@values],"\n"
            $stderr.print expr,"\n"
          end
          if ignore_missing_data
            $stderr.print e.message if not quiet and not empty?
            return false
          else
            raise
          end
        end
      end

      def ifilter expr, ignore_missing_data: false, quiet: false
        begin
          if not respond_to?(:call_cached_ifilter)
            code = 
            """
            def call_cached_ifilter(rec,sample)
              r = rec
              s = sample 
              #{expr}
            end
            """
            self.class.class_eval(code)
          end
          call_cached_ifilter(@rec,self)
        rescue NoMethodError => e
          $stderr.print "\nTrying to evaluate on an empty sample #{@sample.values.to_s}!\n" if not empty? and not quiet
          if not quiet
            $stderr.print [@format,@values],"\n"
            $stderr.print expr,"\n"
          end
          if ignore_missing_data
            $stderr.print e.message if not quiet and not empty?
            return false
          else
            raise
          end
        end
      end

      def efilter expr, ignore_missing_data: false, quiet: false
        begin
          if not respond_to?(:call_cached_efilter)
            code = 
            """
            def call_cached_efilter(rec,sample)
              r = rec
              s = sample 
              #{expr}
            end
            """
            self.class.class_eval(code)
          end
          call_cached_efilter(@rec,self)
        rescue NoMethodError => e
          $stderr.print "\nTrying to evaluate on an empty sample #{@sample.values.to_s}!\n" if not empty? and not quiet
          if not quiet
            $stderr.print [@format,@values],"\n"
            $stderr.print expr,"\n"
          end
          if ignore_missing_data
            $stderr.print e.message if not quiet and not empty?
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

      def cache_method(name, &block)
        self.class.send(:define_method, name, &block)
      end
    
      def method_missing(m, *args, &block)
        name = m.to_s.upcase
        # p [:here,name,m ,@values]
        # p [:respond_to_call_cached_eval,respond_to?(:call_cached_eval)]
        if name =~ /\?$/
          # test for valid field
          return !VcfValue::empty?(fetch_values(name.chop))
        else
          if @format[name]
            cache_method(m) {
              v = fetch_values(name) 
              return nil if VcfValue::empty?(v)
              ConvertStringToValue::convert(v)
            }
            self.send(m)
          else
            super(m, *args, &block)
          end
        end
      end  

  private

      def fetch_values name
        n = @format[name]
        raise "Unknown sample field <#{name}>" if not n
        @values[n]  # <-- save names with upcase!
      end

      def caching_eval method, cached_method, expr, ignore_missing_data: false, quiet: false, do_cache: true
        begin
          if do_cache
            if not respond_to?(cached_method)
              code = 
              """
              def #{cached_method}(rec,sample)
                r = rec
                s = sample 
                #{expr}
              end
              """
              self.class.class_eval(code)
            end
            self.send(cached_method,@rec,self)
          else 
            # This is used for testing mostly
            print "WARNING: NOT CACHING #{method}\n"
            self.class.class_eval { undef :call_cached_eval } if respond_to?(cached_method)
            r = @rec
            s = @sample
            eval(expr)
          end
        rescue NoMethodError => e
          $stderr.print "\n#{method} trying to evaluate on an empty sample #{@sample.values.to_s}!\n" if not empty? and not quiet
          if not quiet
            $stderr.print [@format,@values],"\n"
            $stderr.print expr,"\n"
          end
          if ignore_missing_data
            $stderr.print e.message if not quiet and not empty?
            return false
          else
            raise
          end
        end
      end

    end

  end
end
