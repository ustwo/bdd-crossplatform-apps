require 'open3'
require 'thread'
require 'httparty'
require 'appium_lib'
require_relative 'mock_backend/mock_backend'
require_relative 'element_ids_android'
require_relative 'element_ids_ios'

class CustomWorld

  def initialize platform
    @platform = platform
  end

  def get_driver
    $driver
  end

  def launch_to_commit_list_screen
  	screen = CommitListScreen.new (element_ids)
    screen.wait_for_load
    screen
  end

  def element_ids
    if (@platform == 'android')
      ids = ElementIdsAndroid.ids
    elsif (@platform == 'ios')
      ids = ElementIdsIos.ids
    else
      raise 'Unexpected platform: ' + @platform + ' cannot initialise ids'
    end
  end
end

# Get the platform from rake
platform = ENV['_PLATFORM']
puts 'Platform: ' + platform

World do
  CustomWorld.new(platform)
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
