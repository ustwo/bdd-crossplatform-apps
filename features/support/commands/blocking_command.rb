require 'open3'

class BlockingCommand

  attr_accessor :cmd, :status

  def execute

    puts "About to execute: #{@cmd}"

    Open3.popen3 @cmd do |stdin, stdout, stderr, wait_thr|

      [stdout, stderr].each do |stream|

        Thread.new do
          until (line = stream.gets).nil? do
            puts line
          end
        end
      end
      wait_thr.join
      @status = wait_thr.value.exitstatus

      puts "Exited with status: #{@status}"
    end
  end
end
