require 'tenjin'
require 'uri'
require 'yaml'
require_relative 'features/support/commands/cucumber_command'
require_relative 'features/support/commands/xcodebuild_command'
require_relative 'features/support/commands/gradle_command'
require_relative 'features/support/mock_backend/mock_backend'

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

  android_config_file = 'android_config.yml'

  if File.exist?(android_config_file)

    device = YAML.load(File.read(android_config_file))['device']
    apk = 'android/app/build/outputs/apk/app-local-debug.apk'
    appium_txt = tenjin.render('appium_android.txt', {device: device, apk: apk})
    File.write('appium.txt', appium_txt)
  else

    abort "Cannot find Android configuration file, please add one to the root folder. You can find an example in the templates folder."
  end
end

desc 'Runs Cucumber, please pass tags using @ and NO space between them!'
task :cucumber, [:platform, :tags] do |t, args|

  platform = args[:platform]

  if platform.nil? || !platform.match(/^(ios|android)$/i)
    raise "Please set a valid platform [ios|android]"
  end

  raw_tags = args[:tags]

  tags = []

  if !raw_tags.nil?
    raw_tags.split('@').each do |tag|
      if tag.size > 0
        tags << '@' + tag
      end
    end
  end

  CucumberCommand.new(platform, tags).execute
end

desc 'Runs the BDD test suite for Android'
task :android_bdd, [:tags] => [:android_set_mock_server_url,
                      :android_compile,
                      :android_appium_config] do |t, args|

  # need to invoke by hand to pass on parameters
  Rake::Task[:cucumber].invoke('android', args[:tags])
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

  # NOTE (JD): the final path will be 'ios/build'
  # because we change the working directory before
  # executing xcodebuild
  build_dir = 'build/'
  scheme = 'AppTestingSample-BDD'
  configuration = 'AppTestingSample-BDD'

  # compile
  Dir.chdir('ios/')
  XCodeBuildCommand.new(scheme, configuration, build_dir).execute
  Dir.chdir('../')
end

desc 'Generates the appium.txt file for iOS'
task :ios_appium_config do

  puts "Generating appium.txt"

  ios_config_file = 'ios_config.yml'

  if File.exist?(ios_config_file)

    config = YAML.load(File.read(ios_config_file))
    device = config['device']
    os = config['os']
    app = "ios/build/Release-iphonesimulator/AppTestingSample-BDD.app"
    appium_txt = tenjin.render('appium_ios.txt', {app: app, device: device, os: os})

    File.write('appium.txt', appium_txt)
  else
    abort "Cannot find iOS configuration file, please add one to the root folder. You can find an example in the templates folder."
  end
end

desc 'Runs the BDD test suite for iOS'
task :ios_bdd, [:tags] =>
                  [:ios_set_mock_server_url,
                  :ios_compile,
                  :ios_appium_config] do |t, args|


  # need to invoke by hand to pass on parameters
  Rake::Task[:cucumber].invoke('ios', args[:tags])
end

def tenjin
  Tenjin::Engine.new(path: ['templates'])
end
