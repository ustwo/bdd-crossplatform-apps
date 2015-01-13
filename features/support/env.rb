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

GitHubMockBackend::Boot.boot

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
