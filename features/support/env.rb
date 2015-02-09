require 'open3'
require 'thread'
require 'httparty'
require 'appium_lib'
require 'yaml'
require_relative 'mock_backend/mock_backend'
require_relative '../step_definitions/screen_factory'

class CustomWorld

  def initialize screen_factory
    @screen_factory = screen_factory
  end

  def launch_to_screen screen
    app_launch
    screen.wait_for_load
    screen
  end

  def launch_to_commit_list_screen
    launch_to_screen @screen_factory.get_commit_list_screen()
  end

  def get_commit_detail_screen
    commit_detail_screen = @screen_factory.get_commit_detail_screen()
    commit_detail_screen.wait_for_load
    commit_detail_screen
  end

  def app_close
    $driver.close_app
  end

  private
  def app_launch

    # NOTE (JD): Not been able to find a cleaner way
    # to workout whether an Appium session is already going
    # Accessing the session id triggers an exception if there
    # isn't one going.
    # The code below effectively calls 'start_driver' once
    # and 'launch_app' afterwards

    begin
      $driver.session_id
      $driver.launch_app
    rescue
      $driver.start_driver
    end
  end
end

World do
  CustomWorld.new(ScreenFactory.new(ENV['PLATFORM']))
end

GitHubMockBackend::Boot.boot({stop_if_running: true})

# Appium
caps = Appium.load_appium_txt file: 'appium.txt', verbose: true
Appium::Driver.new({:caps => caps, :custom_url => ENV['APPIUM_SERVER_URL']})
Appium.promote_appium_methods CustomWorld
