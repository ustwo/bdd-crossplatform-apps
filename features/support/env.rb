require 'open3'
require 'thread'
require 'httparty'
require 'appium_lib'
require 'yaml'
require_relative 'mock_backend/mock_backend'
require_relative '../step_definitions/screen_factory'

class CustomWorld

  def initialize driver, screen_factory
    @@driver = driver
    @screen_factory = screen_factory
  end

  def launch_to_commit_list_screen wait_for_load: true

    app_launch
    screen = @screen_factory.get_commit_list_screen()

    if wait_for_load
      screen.wait_for_load
    end

    screen
  end

  def get_commit_detail_screen
    commit_detail_screen = @screen_factory.get_commit_detail_screen()
    commit_detail_screen.wait_for_load
    commit_detail_screen
  end

  def app_close
    @@driver.close_app
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
      @@driver.session_id
      @@driver.launch_app
    rescue
      @@driver.start_driver
    end
  end

  def self.exit
    @@driver.driver_quit
  end
end

GitHubMockBackend::Boot.boot(stop_if_running: true)

caps = Appium.load_appium_txt file: 'appium.txt', verbose: true
driver = Appium::Driver.new({:caps => caps, :custom_url => ENV['APPIUM_SERVER_URL']})
Appium.promote_appium_methods CustomWorld

World do
  screen_factory = ScreenFactory.new(ENV['PLATFORM'], driver)
  CustomWorld.new(driver, screen_factory)
end
