require_relative 'blocking_command'

class XCodeBuildCommand < BlockingCommand
  def initialize(build_dir: "build/", scheme: "AppTestingSample-BDD")
    cmd = "xcodebuild "
    cmd << "-scheme #{scheme} "
    cmd << "-derivedDataPath #{build_dir} "
    cmd << "-configuration #{scheme} "
    cmd << "OBJROOT=#{build_dir} "
    cmd << "SYMROOT=#{build_dir} "
    cmd << "-sdk iphonesimulator "
    cmd << "build"
    @cmd = cmd
  end
end
