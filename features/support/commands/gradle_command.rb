require_relative 'blocking_command'

class GradleCommand < BlockingCommand

  def initialize
    @cmd = './gradlew assembleLocalDebug'
  end
end
