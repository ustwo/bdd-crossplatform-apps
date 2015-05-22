# https://github.com/cucumber/cucumber/wiki/A-Whole-New-World

class CustomWorld
  def initialize(driver, screen_factory)
    @@driver = driver
    @screen_factory = screen_factory
  end

  def launch_to_commit_list_screen(wait_for_load: true)
    app_launch
    screen = @screen_factory.get_commit_list_screen

    screen.wait_for_load if wait_for_load

    screen
  end

  def get_commit_detail_screen
    @screen_factory.get_commit_detail_screen
  end

  def is_on_screen screen
    begin
      element = @@driver.find_element(id: screen.id)
      !element.nil? && element.displayed?
    rescue
      false
    end
  end

  def app_close
    @@driver.close_app
  end

  private

  def app_launch
    # NOTE (JD): Not been able to find a cleaner way
    # to workout whether an Appium session is already going
    # Accessing the session id triggers an exception if there
    # isn't one going.
    # The code below effectively calls 'start_driver' once
    # and 'launch_app' afterwards

    begin
      @@driver.session_id
      @@driver.launch_app
    rescue
      @@driver.start_driver
    end
  end

  def self.exit
    @@driver.driver_quit
  end
end
