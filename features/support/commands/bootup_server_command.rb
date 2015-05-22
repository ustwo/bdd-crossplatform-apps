require 'rack'
require_relative '../mock_backend/server'

class BootupServerCommand
  def initialize(host, port)
    @host = host
    @port = port
  end

  def execute
    @thread = Thread.new do
      Rack::Server.start(app: GitHubMockBackend::API, Host: @host, Port: @port)
    end
  end

  def close
    @thread.exit
  end
end
