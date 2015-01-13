require_relative 'blocking_command'

class XCodeBuildCommand < BlockingCommand

  def initialize scheme, configuration, tmpdir 
    @cmd = "xcodebuild -scheme #{scheme} -derivedDataPath #{tmpdir} -configuration #{configuration} OBJROOT=#{tmpdir} SYMROOT=#{tmpdir} -sdk iphonesimulator build"
  end
end
