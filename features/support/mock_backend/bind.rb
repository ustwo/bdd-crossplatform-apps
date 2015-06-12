 # 
 # The MIT License (MIT)
 # 
 # Copyright (c) 2015 ustwo™
 # 
 # Permission is hereby granted, free of charge, to any person obtaining a copy
 # of this software and associated documentation files (the "Software"), to deal
 # in the Software without restriction, including without limitation the rights
 # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 # copies of the Software, and to permit persons to whom the Software is
 # furnished to do so, subject to the following conditions:

 # The above copyright notice and this permission notice shall be included in all
 # copies or substantial portions of the Software.
 # 
 # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 # SOFTWARE.

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
