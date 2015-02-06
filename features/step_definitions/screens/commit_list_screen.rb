require_relative 'base_screen'

class CommitListScreen < BaseScreen

	def get_title
		get_text(:commitlist_title)
	end

	def click_on_commit index
		$driver.find_elements(id: ids[:commitlist_row])[index].click
	end

	def has_commit_message text
		!$driver.find_element(name: text).nil?
	end

	def has_date text
		!$driver.find_element(name: text).nil?
	end

	def has_no_commits_indicator
		$driver.find_element(id: ids[:commitlist_no_commits_indicator]).displayed?
	end

	def has_loading_indicator
		has_element(ids[:commitlist_loading_indicator])
	end

	def has_no_loading_indicator
		has_no_element(ids[:commitlist_loading_indicator])
	end

	def get_number_of_commits
		$driver.find_elements(name: ids[:commit_list_list_row]).count
	end

	def get_commit_list
		$driver.find_element(id: ids[:commitlist_list])
	end

	private
	def has_element id
		begin
			element = $driver.find_element(id: id)
			!element.nil? && element.displayed?
		rescue
			false
		end
	end

	def has_no_element id

		found = nil

		$driver.set_wait(0)
		$driver.wait_true {
			!has_element(id: id)
		}

		$driver.set_wait(30)

		!found
	end

	def get_text id
		$driver.find_element(id: ids[id]).text
	end

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
