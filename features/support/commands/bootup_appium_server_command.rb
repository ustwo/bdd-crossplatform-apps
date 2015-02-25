require_relative 'non_blocking_command'

class BootupAppiumServerCommand < NonBlockingCommand
  def initialize(host, port)
    @cmd = "node node_modules/appium/bin/appium -a #{host} -p #{port}"
  end
end
