require 'fileutils'

module RegressionTest

  DEFAULT_TESTDIR = "test/data/regression"

  # Regression test runner compares output in ./test/data/regression
  # (by default).  The convention is to have a file with names .ref
  # (reference) and create .new
  #
  # You can add an :ignore regex option which ignores lines in the
  # comparson files matching a regex
  #
  # :timeout sets the time out for calling a system command
  #
  # :should_fail expects the system command to return a non-zero
  module CliExec
    FilePair = Struct.new(:outfn,:reffn)

    def CliExec::exec command, testname, options = {}
      # ---- Find .ref file
      fullname = DEFAULT_TESTDIR + "/" + testname 
      basefn = if File.exist?(testname+".ref") || File.exist?(testname+"-stderr.ref")
                testname 
              elsif File.exist?(fullname + ".ref") || File.exist?(fullname+"-stderr.ref")
                FileUtils.mkdir_p DEFAULT_TESTDIR
                fullname
              else
                raise "Can not find reference file for #{testname} - expected #{fullname}.ref"
              end
      std_out = FilePair.new(basefn + ".new", basefn + ".ref")
      std_err = FilePair.new(basefn + "-stderr.new", basefn + "-stderr.ref")
      files = [std_out,std_err]
      # ---- Create .new file
      cmd = command + " > #{std_out.outfn} 2>#{std_err.outfn}"
      $stderr.print cmd,"\n"
      exec_ret = nil
      if options[:timeout] && options[:timeout] > 0
        Timeout.timeout(options[:timeout]) do
          begin
            exec_ret = Kernel.system(cmd)
          rescue Timeout::Error
            $stderr.print cmd, " failed to finish in under #{options[:timeout]}\n"
            return false
          end
        end
      else
        exec_ret = Kernel.system(cmd)
      end
      expect_fail = (options[:should_fail] != nil)
      if !expect_fail and exec_ret==0
        $stderr.print cmd," returned an error\n"
        return false 
      end
      if expect_fail and exec_ret
        $stderr.print cmd," did not return an error\n"
        return false 
      end
      if options[:ignore]
        regex = options[:ignore]
        files.each do |f|
          outfn = f.outfn
          outfn1 = outfn + ".1"
          FileUtils.mv(outfn,outfn1)
          f1 = File.open(outfn1)
          f2 = File.open(outfn,"w")
          f1.each_line do | line |
            f2.print(line) if line !~ /#{regex}/
          end
          f1.close
          f2.close
          FileUtils::rm(outfn1)
        end
      end
      # ---- Compare the two files
      files.each do |f|
        next unless File.exist?(f.reffn)
        return false unless compare_files(f.outfn,f.reffn,options[:ignore])
      end
      return true
    end

    def CliExec::compare_files fn1, fn2, ignore = nil
      if not File.exist?(fn2)
        FileUtils::cp(fn1,fn2)
        true
      else
        cmd = "diff #{fn2} #{fn1}"
        $stderr.print cmd+"\n"
        return true if Kernel.system(cmd) == true
        # Hmmm. We have a different result. We are going to try again
        # because sometimes threads have not completed
        sleep 0.25 
        return true if Kernel.system(cmd) == true
        $stderr.print "If it is correct, execute \"cp #{fn1} #{fn2}\", and run again"
        false
      end
    end
  end

end
