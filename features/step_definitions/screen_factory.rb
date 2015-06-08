class ScreenFactory

  def initialize platform, driver
    @platform = platform
    @driver = driver

    # Sanity check the platform
    if @platform != "android" && @platform != "ios"
      raise "Unexpected platform '#{@platform}'. Only 'android' and 'ios' supported."
    end
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
      Object::const_get("Android#{screen_name}").new(@platform, @driver)
    when 'ios'
      Object::const_get("Ios#{screen_name}").new(@platform, @driver)
    end
  end
end
