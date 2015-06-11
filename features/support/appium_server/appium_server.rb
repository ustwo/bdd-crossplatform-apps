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
require_relative '../commands/bootup_appium_server_command'

class AppiumServer

    @@command = nil
    @@host = nil
    @@port = nil

    def self.boot host, port

      @@host = host
      @@port = port

      if self.is_running?
        puts "Appium server already running at #{self.url}"
      else
        @@command = BootupAppiumServerCommand.new(@@host, @@port)
        @@command.execute

        while true
          break if self.is_running?
          puts 'Waiting for the Appium server to boot up'
          sleep 1
        end
      end
    end

    def self.close
      if !@@command.nil?
        @@command.close
        puts "Appium server finished"
      end
    end

    def self.url
      "http://#{@@host}:#{@@port}"
    end

    private
    def self.is_running?
      status_url = "#{self.url}/wd/hub/status"
      begin
        HTTParty.get(status_url).response.code.to_i == 200
        sleep 1
      rescue
        false
      end
    end
end
