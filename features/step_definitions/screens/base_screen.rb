#
# Class BaseScreen
#
# @author Juan Delgato <juan@ustwo.com>
#
class BaseScreen
  def initialize(driver)
    @driver = driver
  end

  def id
    fail 'Abstract'
  end

  def wait_for_load
    # NOTE (JD): get rid of the sleep
    # and monitor the state of the loaders
    sleep 2
  end

  def ids
    fail 'SubclassResponsibility - your AndroidScreen/IosScreen should override this method!'
  end

  private

  def element(id)
    @driver.find_element(id: id)
  end

  def elements(id)
    @driver.find_elements(id: id)
  end

  def element_by_text(text)
    @driver.find_element(name: text)
  end

  def elements_by_text(text)
    @driver.find_elements(name: text)
  end

  def has_element(id)
    begin
      e = element(id)
      !e.nil? && e.displayed?
    rescue
      false
    end
  end

  def has_no_element(id)
    @driver.set_wait(0)

    has = nil

    500.times do
      has = has_element(id)
      break unless has
      sleep 0.2
    end

    @driver.set_wait(30)
    !has
  end

  def get_text(id)
    element(id).text
  end
end
