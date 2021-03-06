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

require 'tenjin'
require 'uri'
require 'yaml'
require 'httparty'
require_relative 'features/support/commands/cucumber_command'
require_relative 'features/support/commands/xcodebuild_command'
require_relative 'features/support/commands/gradle_command'
require_relative 'features/support/mock_backend/bind'
require_relative 'features/support/mock_backend/boot'
require_relative 'features/support/appium_server/appium_server'

task :default => :android_bdd

desc 'Sets the URL for the mock backend'
task :android_set_mock_server_url do

  puts "Updating mock backend URL"

  # find URL for the local mock server
  mock_backend_url = GitHubMockBackend::Bind.url

  # update strings.xml
  strings_xml = tenjin.render('strings.xml', {url: mock_backend_url})
  File.write('android/app/src/local/res/values/strings.xml', strings_xml)
end

desc 'Compiles the Android app'
task :android_compile do

  puts "Compiling Android app"

  Dir.chdir('android/')
  GradleCommand.new.execute
  Dir.chdir('../')
end

desc 'Generates the appium.txt file for Android'
task :android_appium_config do

  puts "Generating appium.txt"

  config = get_configuration('android')
  device = config['device']
  apk = 'android/app/build/outputs/apk/app-local-debug.apk'
  appium_txt = tenjin.render('appium_android.txt', {device: device, apk: apk})
  File.write('appium.txt', appium_txt)
end

desc 'Boots up an Appium server if there isn\'t one running. Blocks execution afterwards by default.'
task :boot_appium, [:platform, :block] do |t, args|

  platform = args[:platform]
  appium_server_url = URI(get_configuration(platform)['appium_server_url'])
  appium_server_host = appium_server_url.host
  appium_server_port = appium_server_url.port

  AppiumServer.boot(appium_server_host, appium_server_port)

  unless args[:block] && args[:block] == 'false'
    block
  end
end

desc 'Starts an interactive session for Android'
task :android_interactive =>
            [:android_set_mock_server_url,
            :android_compile,
            :android_appium_config] do


  Rake::Task[:boot_appium].invoke('android', 'false')
  Rake::Task[:boot_mock].invoke()
end

desc 'Boots up the mock server if there isn\'t one running. Blocks execution afterwards by default.'
task :boot_mock, [:block] do |t, args|

  GitHubMockBackend::Boot.boot

  unless args[:block] && args[:block] == 'false'
    block
  end
end

desc 'Runs Cucumber, you can specify an optional profile'
task :cucumber, [:platform, :profile] do |t, args|

  platform = args[:platform]

  if platform.nil? || !platform.match(/^(ios|android)$/i)
    raise "Please set a valid platform [ios|android]"
  end

  profile = args[:profile]

  if profile.nil?
    puts "Running Cucumber with default profile"
  else
    puts "Running Cucumber with profile #{profile}"
  end

  appium_server_url = get_configuration(platform)['appium_server_url'] || 'http://localhost:4723'

  CucumberCommand.new(platform, profile, appium_server_url).execute
end

desc 'Runs the BDD test suite for Android. Cucumber profile is optional.'
task :android_bdd, [:profile] => [:android_set_mock_server_url,
                      :android_compile,
                      :android_appium_config] do |t, args|

  # need to invoke by hand to pass on parameters
  Rake::Task[:boot_appium].invoke('android', 'false')
  Rake::Task[:boot_mock].invoke('false')
  Rake::Task[:cucumber].invoke('android', args[:profile])
end

desc 'Sets the URL for the mock backend'
task :ios_set_mock_server_url do

  puts "Updating mock backend URL"

  # find URL for the local mock server
  mock_backend_url = URI(GitHubMockBackend::Bind.url)

  # update server json
  server_json = tenjin.render('server.json', {schema: mock_backend_url.scheme, host: mock_backend_url.host, port: mock_backend_url.port})
  File.write('ios/AppTestingSample/server.json', server_json)
end

desc 'Compiles the iOS app'
task :ios_compile do

  puts "Compiling iOS app"

  Dir.chdir('ios/')
  XCodeBuildCommand.new.execute
  Dir.chdir('../')
end

desc 'Generates the appium.txt file for iOS'
task :ios_appium_config do

  puts "Generating appium.txt"

  config = get_configuration('ios')
  device = config['device']
  os = config['os']
  app = "ios/build/Release-iphonesimulator/AppTestingSample-BDD.app"
  appium_txt = tenjin.render('appium_ios.txt', {app: app, device: device, os: os})

  File.write('appium.txt', appium_txt)
end

desc 'Starts an interactive session for iOS'
task :ios_interactive => [:ios_set_mock_server_url,
              :ios_compile,
              :ios_appium_config] do

  Rake::Task[:boot_appium].invoke('ios', 'false')
  Rake::Task[:boot_mock].invoke()
end

desc 'Runs the BDD test suite for iOS. Cucumber profile is optional.'
task :ios_bdd, [:profile] =>
                  [:ios_set_mock_server_url,
                  :ios_compile,
                  :ios_appium_config] do |t, args|

  # need to invoke by hand to pass on parameters
  Rake::Task[:boot_appium].invoke('ios', 'false')
  Rake::Task[:boot_mock].invoke('false')
  Rake::Task[:cucumber].invoke('ios', args[:profile])
end

def block

  puts "Waiting here. CTRL + C when you are done."

  while true
    sleep 0.1
    # http://en.wikipedia.org/wiki/Unix_signal
    Signal.trap("INT") do
      exit
    end
  end
end

def tenjin
  Tenjin::Engine.new(path: ['templates'])
end

def get_configuration platform

  case platform.downcase
  when 'android'
    config_file_path = 'android_config.yml'
  when 'ios'
    config_file_path = 'ios_config.yml'
  else
    abort "Unknown platform #{platform}"
  end

  if File.exist?(config_file_path)
    YAML.load(File.read(config_file_path))
  else
    abort "Cannot find configuration file, please add one to the root folder. You can find examples in the templates folder."
  end
end

at_exit do
  GitHubMockBackend::Boot.exit
  AppiumServer.close
end
