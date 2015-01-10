require 'tmpdir'

# NOTE (JD): this is tmp work until
# we get cuesmash to do most of it

task :default => :bdd_android

task :bdd_android do

  Dir.chdir('android/')

  puts `./gradlew a`

  Dir.chdir('../')

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
