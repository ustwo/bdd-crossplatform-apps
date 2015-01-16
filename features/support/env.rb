require 'open3'
require 'thread'
require 'httparty'
require 'appium_lib'
require_relative 'mock_backend/mock_backend'
require_relative 'element_ids_android'
require_relative 'element_ids_ios'

class CustomWorld

  def initialize ids
    @ids = ids
  end

  def get_driver
    $driver
  end

  def launch_to_commit_list_screen
  	screen = CommitListScreen.new (@ids)
    screen.wait_for_load
    screen
  end
end

class FactoryId

  def self.get_ids platform

    case platform
    when 'android'
      ElementIdsAndroid.ids
    when 'ios'
      ElementIdsIos.ids
    else
      raise "Unexpected platform '#{platform}', cannot initialise ids"
    end
  end
end

World do
  CustomWorld.new(FactoryId.get_ids(ENV['_PLATFORM']))
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
