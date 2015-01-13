require_relative 'non_blocking_command'

class ShotgunCommand < NonBlockingCommand

  def initialize host, port, config_ru_path
    @cmd = "shotgun -o #{host} -p #{port} #{config_ru_path}"
  end
end
