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

require_relative 'blocking_command'

class CucumberCommand < BlockingCommand

  def initialize platform, tags, appium_server_url

    @cmd = "cucumber -c PLATFORM=#{platform} APPIUM_SERVER_URL=#{appium_server_url}"

    if !tags.nil? && tags.size > 0

      # NOTE (JD): Cucumber tags can get pretty complex, choosing
      # the simplest option here for now. Haven't been able to find
      # a decent way of getting Cucumber and Rake to get on well because
      # of how rake tasks get parameters. I'm all ears.
      # More info:
      #   * https://github.com/cucumber/cucumber/wiki/Tags
      @cmd = @cmd + ' --tags ' + tags.join(',')
    end
  end
end
