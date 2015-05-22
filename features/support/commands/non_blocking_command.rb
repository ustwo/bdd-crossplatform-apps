class NonBlockingCommand
  attr_accessor :cmd, :status, :pid

  def execute
    puts "About to execute: #{@cmd}"

    @stdin, @stdout, @stderr, wait_thr = Open3.popen3(@cmd)

    [@stdout, @stderr].each do |stream|
      Thread.new do
        until (line = stream.gets).nil?
          puts line
        end
      end
    end

    @pid = wait_thr[:pid]
    @pid
  end

  def close
    @stdin.close
    @stdout.close
    @stderr.close

    puts "About to kill process: #{@pid}"

    `kill -9 #{@pid}`
  end
end
