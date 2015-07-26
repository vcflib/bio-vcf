# Parallel copy-on-write streaming (PCOWS)

class PCOWS

  def initialize(num_threads,name=__FILE__)
    @num_threads = num_threads
    @thread_list = []
    @name = name
    @tmpdir =  Dir::mktmpdir(@name+'_')
    @count = 0
  end

  # Feed the func and state to COWS. Note that func is a closure so it
  # can pick up surrounding scope at invocation in addition to the
  # data captured in 'state'.
  
  def run(func,state,tmpdir,num_threads)
    pid = nil
    if num_threads and num_threads>1
      @count += 1
      threadfilen = mktmpfilename(tmpdir,@count)
      pid = fork do
        # ---- This is running a new copy-on-write process
        tempfn = threadfilen+'.part'
        STDOUT.reopen(File.open(tempfn, 'w+'))
        func.call(state)
        STDOUT.flush
        STDOUT.close
        FileUtils::mv(tempfn,threadfilen)
        exit 0
      end
    else
      # ---- Call in main process
      func.call(state)
    end
    @thread_list << [ pid,@count,threadfilen ]
    return true
  end

  # Make sure no more than num_threads are running at the same time -
  # this is achieved by checking the PID table and the running files
  # in the tmpdir
  def wait_for_threadpool(thread_list, num_threads)
    while true
      # ---- count running pids
      running = thread_list.reduce(0) do | sum, thread_info |
        if thread_info[0] && pid_running?(thread_info[0])
          sum+1
        elsif thread_info[0]==nil && File.exist?(thread_info[1]+'.part')
          sum+1
        else
          sum
        end
      end
      break if running < num_threads
      sleep 0.1
    end
  end

  def pid_running?(pid)
    begin
      fpid,status=Process.waitpid2(pid,Process::WNOHANG)
    rescue Errno::ECHILD, Errno::ESRCH
      return false
    end
    return true if nil == fpid && nil == status
    return ! (status.exited? || status.signaled?)
  end
  
  # ---- In this section the output gets collected and printed on STDOUT
  def cleanup
    if options[:num_threads]
      STDOUT.reopen(orig_std_out)
      $stderr.print "Final pid=#{thread_list.last[0]}, size=#{lines.size}\n"
      lines = []

      fault = false
      # Wait for the running threads to complete
      thread_list.each do |info|
        (pid,threadfn) = info
        tempfn = threadfn + '.running'
        timeout = 180
        if (pid && !pid_running?(pid)) || fault
          # no point to wait for a long time if we've failed one already or the proc is dead
          timeout = 1
        end
        $stderr.print "Waiting up to #{timeout/60} minutes for pid=#{pid} to complete\n"
        begin
          Timeout.timeout(timeout) do
            while not File.exist?(threadfn)  # wait for the result to appear
              sleep 0.2
            end
          end
          # Thread file should have gone:
          raise "FATAL: child process appears to have crashed #{tempfn}" if File.exist?(tempfn)
          $stderr.print "OK pid=#{pid}\n"
        rescue Timeout::Error
          if pid_running?(pid)
            Process.kill 9, pid
            Process.wait pid
          end
          $stderr.print "FATAL: child process killed because it stopped responding, pid = #{pid}\n"
          fault = true
        end
      end
      # Collate the output
      thread_list.each do | info |
        (pid,fn) = info
        if !fault
          # This should never happen
          raise "FATAL: child process output #{fn} is missing" if not File.exist?(fn)
          $stderr.print "Reading #{fn}\n"
          File.new(fn).each_line { |buf|
            print buf
          }
          File.unlink(fn)
        end
        Process.wait(pid) if pid && pid_running?(pid)
      end
      return 1 if fault
    end
  end  # cleans up tempdir

  protected
  
  def mktmpfilename(num)
    @tmpdir+sprintf("/%0.6d-",num)+@name
  end

end
