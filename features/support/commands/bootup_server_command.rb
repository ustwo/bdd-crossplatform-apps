require_relative 'non_blocking_command'

class BootupServerCommand < NonBlockingCommand

  def initialize host, port
    @cmd = "rackup features/support/mock_backend/config.ru -o #{host} -p #{port}"
  end
end
