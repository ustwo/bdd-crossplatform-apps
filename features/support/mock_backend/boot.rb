require 'httparty'

require_relative 'bind'
require_relative '../commands/bootup_server_command'

module GitHubMockBackend

  # Wraps functionality to boot up the local mock server.
  class Boot
    @command = nil
    @@boot = nil

    def initialize
      host = Bind.host
      port = Bind.port
      full_url = Bind.url

      if self.is_running?
        puts "Mock server already running at #{full_url}."
      else

        puts "About to boot up mock server at: #{full_url}"

        @command = BootupServerCommand.new(host, port)
        @command.execute

        while true

          break if self.is_running?
          puts 'Waiting for mock backend'
          sleep 2
        end

        puts "Mock server up and running"
      end
    end

    def is_running?
      begin
        HTTParty.get(Bind.url).response.code.to_i == 200
      rescue Errno::ECONNREFUSED => e
        false
      end
    end

    def close
      if !@command.nil?
        @command.close
        puts "Mock server finished"
      end
    end

    # Boots a local mock server, if required.
    def self.boot
      @@boot = Boot.new
    end

    # Ends the local mock server.
    def self.exit
      if !@@boot.nil?
        @@boot.close
      end
    end
  end

end
