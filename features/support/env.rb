# require 'appium_lib'
# require './features/step_definitions/screen'
#
require 'open3'
require 'thread'
require 'httparty'
require_relative 'mock_backend/mock_backend'

class CustomWorld

  def get_driver
    $driver
  end
end

#
# # Load the desired configuration from appium.txt, create a driver then
# # Add the methods to the world
# caps = Appium.load_appium_txt file: File.expand_path('./', __FILE__), verbose: true
# Appium::Driver.new(caps)
# Appium.promote_appium_methods AppiumWorld
#

World do
  CustomWorld.new
end

# mix of these two:
# http://stackoverflow.com/questions/14019287/get-the-ip-address-of-local-machine-rails
# http://stackoverflow.com/questions/5029427/ruby-get-local-ip-nix

HOST = Socket.ip_address_list.find { |a| a.ipv4? && !a.ipv4_loopback? }.ip_address
PORT = 9999

GitHubMockBackend::Boot.boot(HOST, PORT)
