require 'tmpdir'
require 'tenjin'
require 'uri'
require_relative 'features/support/mock_backend/mock_backend'

task :default => :bdd_ios

task :bdd_android do

  puts "Android"

  tenjin = Tenjin::Engine.new(path: ['templates'])

  # find URL for the local mock server
  mock_backend_url = GitHubMockBackend::Bind.url

  # update strings.xml
  strings_xml = tenjin.render('strings.xml', {url: mock_backend_url})
  File.write('android/app/src/local/res/values/strings.xml', strings_xml)

  # compile
  Dir.chdir('android/')
  puts `./gradlew assembleLocalDebug`
  Dir.chdir('../')

  # appium.txt
  device = 'appium' # <-- emulator or device ID, must be connected and/or already running
  apk = 'android/app/build/outputs/apk/app-debug.apk'
  appium_txt = tenjin.render('appium_android.txt', {device: device, apk: apk})

  File.write('appium.txt', appium_txt)

  # cucumber
  puts `cucumber`
end

task :bdd_ios do

  puts "iOS"

  tenjin = Tenjin::Engine.new(path: ['templates'])

  # find URL for the local mock server
  mock_backend_url = URI(GitHubMockBackend::Bind.url)

  # update server json
  server_json = tenjin.render('server.json', {schema: mock_backend_url.scheme, host: mock_backend_url.host, port: mock_backend_url.port})
  File.write('ios/AppTestingSample/server.json', server_json)

  tmpdir = Dir.mktmpdir
  scheme = 'AppTestingSample'
  build_configuration = 'AppTestingSample-BDD'

  # compile
  puts tmpdir
  Dir.chdir('ios/')
  puts `xcodebuild -scheme #{scheme} -derivedDataPath #{tmpdir} -configuration #{build_configuration} OBJROOT=#{tmpdir} SYMROOT=#{tmpdir} -sdk iphonesimulator build`
  Dir.chdir('../')

  # appium.txt
  # device = 'appium' # <-- emulator or device ID, must be connected and/or already running
  app = "#{tmpdir}/Release-iphonesimulator/AppTestingSample.app"
  appium_txt = tenjin.render('appium_ios.txt', {app: app})

  File.write('appium.txt', appium_txt)

  # cucumber
  puts `cucumber`

  # clean up
  FileUtils.rm_rf(tmpdir)
end
