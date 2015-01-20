require_relative 'screens/android_commit_list_screen'
require_relative 'screens/ios_commit_list_screen'

class ScreenFactory

  def initialize platform
    @platform = platform

    @androidScreens = {commitlist: AndroidCommitListScreen.new()}
    @iosScreens = {commitlist: IosCommitListScreen.new()}
  end
  
  def get_commit_list_screen
    get_screen_by_key :commitlist
  end

  def get_screen_by_key key
    case @platform
    when 'android'
      @androidScreens[key]
    when 'ios'
      @iosScreens[key]
    else
      raise "Unexpected platform '#{@platform}', cannot get get screen by key '#{key}'"
    end
  end

end