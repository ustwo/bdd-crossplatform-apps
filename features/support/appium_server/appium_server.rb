require 'httparty'
require_relative '../commands/bootup_appium_server_command'

class AppiumServer
  @@command = nil
  @@host = nil
  @@port = nil

  def self.boot(host, port)
    @@host = host
    @@port = port

    if self.is_running?
      puts "Appium server already running at #{url}"
    else
      @@command = BootupAppiumServerCommand.new(@@host, @@port)
      @@command.execute

      loop do
        break if self.is_running?
        puts 'Waiting for the Appium server to boot up'
        sleep 1
      end
    end
  end

  def self.close
    unless @@command.nil?
      @@command.close
      puts 'Appium server finished'
    end
  end

  def self.url
    "http://#{@@host}:#{@@port}"
  end

  private

  def self.is_running?
    status_url = "#{url}/wd/hub/status"
    begin
      HTTParty.get(status_url).response.code.to_i == 200
      sleep 1
    rescue
      false
    end
  end
end
