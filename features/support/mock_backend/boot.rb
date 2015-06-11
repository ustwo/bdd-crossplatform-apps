/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 ustwo™
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

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
