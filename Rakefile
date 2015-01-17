require 'tmpdir'
require 'tenjin'
require 'uri'
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

  device = 'appium' # <-- emulator or device ID, must be connected and/or already running
  apk = 'android/app/build/outputs/apk/app-local-debug.apk'
  appium_txt = tenjin.render('appium_android.txt', {device: device, apk: apk})
  File.write('appium.txt', appium_txt)
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

desc 'Runs the BDD test suite for iOS'
task :ios_bdd, [:tags] do |t, args|

  puts "iOS"
  ENV['PLATFORM'] = 'ios'

  # find URL for the local mock server
  mock_backend_url = URI(GitHubMockBackend::Bind.url)

  # update server json
  server_json = tenjin.render('server.json', {schema: mock_backend_url.scheme, host: mock_backend_url.host, port: mock_backend_url.port})
  File.write('ios/AppTestingSample/server.json', server_json)

  tmpdir = Dir.mktmpdir
  scheme = 'AppTestingSample'
  configuration = 'AppTestingSample-BDD'

  # compile
  puts tmpdir
  Dir.chdir('ios/')
  XCodeBuildCommand.new(scheme, configuration, tmpdir).execute
  Dir.chdir('../')

  # appium.txt
  app = "#{tmpdir}/Release-iphonesimulator/AppTestingSample.app"
  appium_txt = tenjin.render('appium_ios.txt', {app: app})

  File.write('appium.txt', appium_txt)

  # need to invoke by hand to pass on parameters
  Rake::Task[:cucumber].invoke('ios', args[:tags])

  # clean up
  FileUtils.rm_rf(tmpdir)
end

def tenjin
  Tenjin::Engine.new(path: ['templates'])
end
