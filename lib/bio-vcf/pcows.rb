# Parallel copy-on-write streaming (PCOWS)

class PCOWS

  RUNNINGEXT = 'part'
  
  def initialize(num_threads,name=__FILE__)
    num_threads = 1 if !num_threads # FIXME: set to cpu_num by default
    @num_threads = num_threads
    @thread_list = []
    @name = name
    @tmpdir =  Dir::mktmpdir(@name+'_')
  end

  # Feed the worker func and state to COWS. Note that func is a
  # closure so it can pick up surrounding scope at invocation in
  # addition to the data captured in 'state'.
  
  def worker(func,state)
    pid = nil
    if @num_threads>1
      count = @pid_list.size+1
      threadfilen = mktmpfilename(count)
      pid = fork do
        # ---- This is running a new copy-on-write process
        tempfn = threadfilen+'.'+RUNNINGEXT
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
    @pid_list << [ pid,count,threadfilen ]
    return true
  end

  # Make sure no more than num_threads are running at the same time -
  # this is achieved by checking the PID table and the running files
  # in the tmpdir

  def wait_for_threadpool(pid_list)
    while true
      # ---- count running pids
      running = pid_list.reduce(0) do | sum, info |
        [pid,count,pidfn] == info
        if pid && pid_running?(pid)
          sum+1
        elsif File.exist?(pidfn+'.'+RUNNINGEXT)
          sum+1
        else
          sum
        end
      end
      break if running < @num_threads
      sleep 0.1
    end
  end

  
  # ---- In this section the output gets collected and passed on to a
  #      printer thread. Make sure the printing is ordered and that
  #      no printers are running at the same time. The printer thread
  #      should be doing as little processing as possible.
  def cleanup
    if options[:num_threads]
      STDOUT.reopen(orig_std_out)
      $stderr.print "Final pid=#{pid_list.last[0]}, size=#{lines.size}\n"
      lines = []

      fault = false
      # Wait for the running threads to complete
      pid_list.each do |info|
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
      pid_list.each do | info |
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

  private
  
  def mktmpfilename(num)
    @tmpdir+sprintf("/%0.6d-",num)+@name
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

end
