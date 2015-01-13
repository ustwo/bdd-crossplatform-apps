require_relative 'blocking_command'

class CucumberCommand < BlockingCommand

  def initialize
    @cmd = 'cucumber'
  end
end
