# Parallel copy-on-write streaming (PCOWS)

require 'tempfile'

class PCOWS

  RUNNINGEXT = 'part'
  
  def initialize(num_threads,name=File.basename(__FILE__),timeout=180)
    num_threads = cpu_count() if not num_threads # FIXME: set to cpu_num by default
    # $stderr.print "Using ",num_threads,"threads \n"
    @num_threads = num_threads
    @pid_list = []
    @name = name
    @timeout = timeout
    if multi_threaded
      @tmpdir =  Dir::mktmpdir(@name+'_')
    end
    @last_output = 0 # counter
    @output_locked = nil
  end

  # Feed the worker 'func and state' to COWS. Note that func is a
  # lambda closure so it can pick up surrounding scope at invocation
  # in addition to the data captured in 'state'.
  
  def submit_worker(func,state)
    pid = nil
    if multi_threaded
      count = @pid_list.size+1
      fn = mktmpfilename(count)
      pid = fork do
        # ---- This is running a new copy-on-write process
        tempfn = fn+'.'+RUNNINGEXT
        STDOUT.reopen(File.open(tempfn, 'w+'))
        func.call(state).each { | line | print line }
        STDOUT.flush
        STDOUT.close
        FileUtils::mv(tempfn,fn)
        exit 0
      end
    else
      # ---- Single threaded: call in main process and output immediately
      func.call(state).each { | line | print line }
    end
    @pid_list << [ pid,count,fn ]
    return true
  end

  # Make sure no more than num_threads are running at the same time -
  # this is achieved by checking the PID table and the running files
  # in the tmpdir

  def wait_for_worker_slot()
    return if single_threaded
    Timeout.timeout(@timeout) do
    
      while true
        # ---- count running pids
        running = @pid_list.reduce(0) do | sum, info |
          (pid,count,fn) = info
          if pid_or_file_running?(pid,fn)
            sum+1
          else
            sum
          end
        end
        return if running < @num_threads
        $stderr.print "Waiting for slot (timeout=#{@timeout})\n"
        sleep 0.1
        
      end
    end
  end

  # ---- In this section the output gets collected and passed on to a
  #      printer thread. This function makes sure the printing is
  #      ordered and that no printers are running at the same
  #      time. The printer thread should be doing as little processing
  #      as possible.
  #
  #      In this implementation type==:by_line will call func for
  #      each line. Otherwise it is called once with the filename.

  def process_output(func=nil,type = :by_line, blocking: false)
    return if single_threaded
    return if single_threaded
    output = lambda { |fn|
      if type == :by_line
        File.new(fn).each_line { |buf|
          print buf
        }
      else
        func.call(fn)
      end
    }
    if @output_locked
      # ---- is the other thread still running?
      (pid,count,fn) = @output_locked
      return if File.exist?(fn)  # yes, still processing
      @last_output += 1               # next one in line
      @output_locked = nil
    end
    # Walk the pid list to find the next one
    if info = @pid_list[@last_output]
      (pid,count,fn) = info
      if File.exist?(fn)
        # Yes! We have the next output, create outputter
        $stderr.print "Processing #{fn}\n"
        if not blocking
          pid = fork do
            output.call(fn)
            $stderr.print "Removing #{fn}\n"
            File.unlink(fn)
            exit(0)
          end
          @output_locked = info
        else
          output.call(fn)
          $stderr.print "Removing #{fn}\n"
          File.unlink(fn)
        end
      end
    end
  end

  def wait_for_worker(info)
    (pid,count,fn) = info
    if pid_or_file_running?(pid,fn)
      $stderr.print "Waiting up to #{@timeout} seconds for pid=#{pid} to complete\n"
      begin
        Timeout.timeout(@timeout) do
          while not File.exist?(fn)  # wait for the result to appear
            sleep 0.2
          end
        end
        # Thread file should have gone:
        raise "FATAL: child process appears to have crashed #{fn}" if not File.exist?(fn)
        $stderr.print "OK pid=#{pid}, processing #{fn}\n"
      rescue Timeout::Error
        if pid_running?(pid)
          # Kill it to speed up exit
          Process.kill 9, pid
          Process.wait pid
        end
        $stderr.print "FATAL: child process killed because it stopped responding, pid = #{pid}\n"
      end
    end
  end
  
  # This is the final cleanup after the reader thread is done. All workers
  # need to complete.
  
  def wait_for_workers()
    return if single_threaded
    @pid_list.each do |info|
      wait_for_worker(info)
    end
  end

  def process_remaining_output()
    return if single_threaded
    $stderr.print "Processing remaining output..."
    while @output_locked
      process_output()
      sleep 0.2
    end
    @pid_list.each do |info|
      process_output(nil,:by_line,blocking: true)
    end
    # final cleanup
    $stderr.print "Removing dir #{@tmpdir}\n"
    Dir.unlink(@tmpdir) if @tmpdir
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

  def single_threaded
    @num_threads == 1
  end
  
  def multi_threaded
    @num_threads > 1
  end

  def cpu_count
    begin
      return File.read('/proc/cpuinfo').scan(/^processor\s*:/).size if File.exist? '/proc/cpuinfo'
      # Actually, the JVM does not allow fork...
      return Java::Java.lang.Runtime.getRuntime.availableProcessors if defined? Java::Java
    rescue LoadError
      # Count on MAC
      return Integer `sysctl -n hw.ncpu 2>/dev/null`
    end
    $stderr.print "Could not determine number of CPUs"
    1
  end

end
