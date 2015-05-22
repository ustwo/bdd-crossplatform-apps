require_relative 'blocking_command'

class XCodeBuildCommand < BlockingCommand
  def initialize
    build_dir = 'build/'
    scheme = 'AppTestingSample-BDD'
    @cmd = "xcodebuild -scheme #{scheme} -derivedDataPath #{build_dir} -configuration #{scheme} OBJROOT=#{build_dir} SYMROOT=#{build_dir} -sdk iphonesimulator build"
  end
end
