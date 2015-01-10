require 'open3'
require 'thread'
require 'httparty'
require 'appium_lib'
require_relative 'mock_backend/mock_backend'

class CustomWorld

  def get_driver
    $driver
  end
end

World do
  CustomWorld.new
end

# mix of these two:
# http://stackoverflow.com/questions/14019287/get-the-ip-address-of-local-machine-rails
# http://stackoverflow.com/questions/5029427/ruby-get-local-ip-nix

HOST = Socket.ip_address_list.find { |a| a.ipv4? && !a.ipv4_loopback? }.ip_address
PORT = 9999

GitHubMockBackend::Boot.boot(HOST, PORT)

# We can bind Appium to localhost because only the machine
# running the tests needs access to it
APPIUM_SERVER_URL = "http://localhost:4723"

puts "Appium server URL: #{APPIUM_SERVER_URL}"

# Boot up Appium here
# node node_modules/appium/bin/appium -a HOST

# Appium
caps = Appium.load_appium_txt file: 'appium.txt', verbose: true
Appium::Driver.new({:caps => caps, :custom_url => APPIUM_SERVER_URL})
Appium.promote_appium_methods CustomWorld
$driver.start_driver
