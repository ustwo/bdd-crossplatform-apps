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
