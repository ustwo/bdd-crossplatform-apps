/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 ustwo™
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

# https://github.com/cucumber/cucumber/wiki/A-Whole-New-World

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
    @screen_factory.get_commit_detail_screen()
  end

  def is_on_screen screen
    begin
      element = @@driver.find_element(id: screen.id)
      !element.nil? && element.displayed?
    rescue
      false
    end
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
