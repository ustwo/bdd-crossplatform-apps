require_relative 'blocking_command'

class XCodeBuildCommand < BlockingCommand

  def initialize scheme, configuration, build_dir
    @cmd = "xcodebuild -scheme #{scheme} -derivedDataPath #{build_dir} -configuration #{configuration} OBJROOT=#{build_dir} SYMROOT=#{build_dir} -sdk iphonesimulator build"
  end
end
