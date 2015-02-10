class ScreenFactory

  def initialize platform
    @platform = platform
  end
  
  def get_commit_list_screen
    get_screen_by_key "CommitListScreen"
  end

  def get_commit_detail_screen
    get_screen_by_key "CommitDetailScreen"
  end

  def get_screen_by_key screen_name
    case @platform
    when 'android'
      Object::const_get("Android#{screen_name}").new()
    when 'ios'
      Object::const_get("Ios#{screen_name}").new()
    else
      raise "Unexpected platform '#{@platform}', cannot get get screen by screen_name '#{screen_name}'"
    end
  end

end