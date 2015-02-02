require_relative 'base_screen'

class CommitListScreen < BaseScreen

  # Generic
  def get_text id
    $driver.find_element(id: ids[id]).text
  end

  # Title
  def get_title
    get_text(:commitlist_title)
  end

  # Commit list
  def get_commit_list
    $driver.find_element(id: ids[:commitlist_list])
  end

  def click_on_commit index
    $driver.find_elements(id: ids[:commit_list_list_row])[index].click
  end

  def get_number_of_commits
    $driver.find_elements(name: ids[:commit_list_list_row]).count
  end

  # Commit message
  def has_commit_message text
    !$driver.find_element(name: text).nil?
  end

  # Commit date
  def has_date text
    !$driver.find_element(name: text).nil?
  end

  # Loading indication
  def loading_indicator_visible
    begin
      # if we can't find the loading indicator, it's not visible
      $driver.find_element(id: ids[:commitlist_loading_indicator]).displayed?
    rescue
      false
    end
  end

  # Error indication
  def get_commits_error_indicator
    $driver.find_element(id: ids[:commitlist_no_commits_indicator])
  end

  def has_commits_error_indicator
    get_commits_error_indicator.displayed?
  end

  def get_commits_error
    get_commits_error_indicator.text
  end
end
