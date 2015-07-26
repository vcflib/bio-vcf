# Parallel copy-on-write streaming (PCOWS)

class PCOWS

  RUNNINGEXT = 'part'
  
  def initialize(num_threads,name=__FILE__)
    num_threads = 1 if !num_threads # FIXME: set to cpu_num by default
    @num_threads = num_threads
    @pid_list = []
    @name = name
    @tmpdir =  Dir::mktmpdir(@name+'_')
    @last_output = 0 # counter
    @output_locked = nil
  end

  # Feed the worker func and state to COWS. Note that func is a
  # closure so it can pick up surrounding scope at invocation in
  # addition to the data captured in 'state'.
  
  def worker(func,state)
    pid = nil
    if @num_threads>1
      count = @pid_list.size+1
      fn = mktmpfilename(count)
      pid = fork do
        # ---- This is running a new copy-on-write process
        tempfn = fn+'.'+RUNNINGEXT
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
    @pid_list << [ pid,count,fn ]
    return true
  end

  # Make sure no more than num_threads are running at the same time -
  # this is achieved by checking the PID table and the running files
  # in the tmpdir

  def wait_for_threadpool()
    while true
      # ---- count running pids
      running = @pid_list.reduce(0) do | sum, info |
        (pid,count,fn) == info
        if pid_or_file_running?(pid,fn)
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
  #      printer thread. This function makes sure the printing is
  #      ordered and that no printers are running at the same
  #      time. The printer thread should be doing as little processing
  #      as possible.

  def process_output(func)
    if @output_locked
      (pid,count,fn) = @output_locked
      return if File.exist?(fn)  # still processing
      # on to the next one
      @last_output += 1
      @output_locked = nil
    end
    if info = @pid_list[@last_output]
      (pid,count,fn) = info
      if File.exist?(fn)
        # Yes! We have the next output, create outputter
        pid = fork do
          File.new(fn).each_line { |buf|
            func.call(buf)
          }
          File.unlink(fn)
          exit(0)
        end
        @output_locked = info
      end
    end
  end

  # This is the final cleanup after the reader thread is done. All workers
  # need to complete.
  
  def wait_for_children_to_complete
    $stderr.print "Final pid=#{pid_list.last[0]}\n"
    # Wait for the running threads to complete
    pid_list.each do |info|
      (pid,count,threadfn) = info
      tempfn = threadfn + '.'+RUNNINGEXT
      if pid_or_file_running?(pid)
        timeout = 180
        $stderr.print "Waiting up to #{timeout} seconds for pid=#{pid} to complete\n"
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
          raise "FATAL: child process killed because it stopped responding, pid = #{pid}\n"
        end
      end
    end
  end

  private
  
  def mktmpfilename(num,ext=nil)
    @tmpdir+sprintf("/%0.6d-",num)+@name+(ext ? '.'+ext : '')
  end
  
  def pid_or_file_running?(pid,fn)
    (pid && pid_running?(pid)) or File.exist?(fn+'.'+RUNNINGEXT)
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
