require 'socket'

module GitHubMockBackend

  # Utility class used to define the URL of the local mock server.
  class Bind

    # Returns the local IP address of the machine.
    # @return [String]
    def self.host
      # mix of these two:
      # http://stackoverflow.com/questions/14019287/get-the-ip-address-of-local-machine-rails
      # http://stackoverflow.com/questions/5029427/ruby-get-local-ip-nix

      Socket.ip_address_list.find { |a| a.ipv4? && !a.ipv4_loopback? }.ip_address
    end

    # Returns a port.
    # @return [Integer] Hardcoded to 9999.
    def self.port
      9999
    end

    # Returns a URL, combination of host and port.
    # @return [String] "http://HOST:PORT"
    def self.url
      "http://#{Bind.host}:#{Bind.port}"
    end
  end

end
