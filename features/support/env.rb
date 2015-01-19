require 'open3'
require 'thread'
require 'httparty'
require 'appium_lib'
require_relative 'mock_backend/mock_backend'
require_relative 'element_ids_android'
require_relative 'element_ids_ios'

require_relative '../step_definitions/screens/android_commit_list_screen'

class CustomWorld

  def initialize screenFactory
    @screenFactory = screenFactory
  end

  def launch_to_screen screen
    $driver.start_driver
    screen.wait_for_load
    screen
  end

  def launch_to_commit_list_screen
    launch_to_screen @screenFactory.get_commit_list_screen()
  end

end

class ScreenFactory

  def initialize platform
    @platform = platform

    @androidScreens = {commitlist: AndroidCommitListScreen.new(ElementIdsAndroid.ids)}
    @iosScreens = {commitlist: CommitListScreen.new(ElementIdsIos.ids)}
  end
  
  def get_commit_list_screen
    get_screen_by_key :commitlist
  end

  def get_screen_by_key key
    case @platform
    when 'android'
      @androidScreens[key]
    when 'ios'
      @iosScreens[key]
    else
      raise "Unexpected platform '#{@platform}', cannot get get screen by key '#{key}'"
    end
  end

end

World do
  CustomWorld.new(ScreenFactory.new(ENV['PLATFORM']))
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
