#
# Class BaseScreen
#
# @author Juan Delgato <juan@ustwo.com>
#
class BaseScreen
  NO_ELEMENT_LOOP_COUNT = 500

  def initialize(driver)
    @driver = driver
  end

  def id
    fail NotImplementedError, "You must implement a #id method when subclassing"
  end

  def wait_for_load
    # NOTE (JD): get rid of the sleep
    # and monitor the state of the loaders
    sleep 2
  end

  def ids
    fail NotImplementedError, "AndroidScreen/IosScreen should override this method when subclassing"
  end

  private

  def element(id:)
    @driver.find_element(id: id)
  end

  def elements(id:)
    @driver.find_elements(id: id)
  end

  def element_by_text(text:)
    @driver.find_element(name: text)
  end

  def elements_by_text(text:)
    @driver.find_elements(name: text)
  end

  #
  # Check if rendered page has a given element
  #
  # @param [String ] id: accessibility identifier of element
  #
  # @return [Bool]
  #
  def has_element?(id:)
    e = element(id: id)
    !e.nil? && e.displayed? # TODO: break up the nil check so that you know which one is failing.
    rescue
      false
    end
  end


  #
  # Confirm that a certain element does NOT appear on the rendered page
  #
  # @param [<type>] id: <description>
  #
  # @return [<type>] <description>
  #
  def has_no_element?(id:)
    @driver.set_wait(0)

    has = nil
    count = 0

    loop do
      break if count > NO_ELEMENT_LOOP_COUNT
      has = has_element?(id: id)
      break unless has
      count += 1
      sleep 0.2
    end

    ensure @driver.set_wait(30)
    !has
  end

  def get_text(id:)
    element(id).text
  end
end
