require 'tmpdir'
require 'tenjin'
require_relative 'features/support/mock_backend/mock_backend'

task :default => :bdd_android

task :bdd_android do

  puts "Android"

  tenjin = Tenjin::Engine.new(path: ['templates'])

  # update strings.xml
  mock_backend_url = GitHubMockBackend::Bind.url

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

  tmpdir = Dir.mktmpdir
  scheme = 'AppTestingSample'
  build_configuration = 'Debug'

  puts tmpdir

  Dir.chdir('ios/')

  puts `xcodebuild -scheme #{scheme} -derivedDataPath #{tmpdir} -configuration #{build_configuration} OBJROOT=#{tmpdir} SYMROOT=#{tmpdir} -sdk iphonesimulator build`

  Dir.chdir('../')

  puts `cucumber`

  FileUtils.rm_rf(tmpdir)
end
