require 'httparty'

require_relative 'bind'
require_relative '../commands/bootup_server_command'

module GitHubMockBackend

  class Boot
    @@boot = nil

    def initialize
      host = Bind.host
      port = Bind.port
      full_url = Bind.url

      if self.is_running?
        puts "Mock server already running at #{full_url}."
      else

        puts "About to boot up mock server at: #{full_url}"

        @bootup = BootupServerCommand.new(host, port)
        @bootup.execute

        while true

          break if self.is_running?
          puts 'Waiting for mock backend'
          sleep 0.5
        end

        puts "Mock server up and running"
      end
    end

    def is_running?
      begin
        HTTParty.get(Bind.url).response.code.to_i == 200
      rescue
        false
      end
    end

    def close
      @bootup.close
      puts "Mock server finished"
    end

    def self.boot
      @@boot = Boot.new
    end

    def self.exit
      if !@@boot.nil?
        @@boot.close
      end
    end
  end

end
