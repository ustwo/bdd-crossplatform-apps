require 'open3'
require 'thread'
require 'httparty'
require 'appium_lib'
require 'yaml'

require_relative 'custom_world'
require_relative 'mock_backend/boot'
require_relative '../step_definitions/screen_factory'

# Standard Appium configuration other than note we don't
# use a global variable for the driver
caps = Appium.load_appium_txt file: 'appium.txt', verbose: true
driver = Appium::Driver.new({:caps => caps, :custom_url => ENV['APPIUM_SERVER_URL']})
Appium.promote_appium_methods CustomWorld

# Using a custom world to add a few helpers to be used in the step defs.
# See: # https://github.com/cucumber/cucumber/wiki/A-Whole-New-World
World do
  screen_factory = ScreenFactory.new(ENV['PLATFORM'], driver)
  CustomWorld.new(driver, screen_factory)
end
