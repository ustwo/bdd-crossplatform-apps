require 'rack'
require_relative '../mock_backend/server'

class BootupServerCommand
  def initialize(host, port)
    @host = host
    @port = port
  end

  def execute
    @thread = Thread.new { Rack::Server.start(app: GitHubMockBackend::Server, Host: @host, Port: @port) }
  end

  def close
    @thread.exit
  end
end
