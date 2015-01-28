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

	# Commit message
	def has_commit_message text
		!$driver.find_element(name: text).nil?
	end

	# Commit date
	def has_date text
		!$driver.find_element(name: text).nil?
	end

	# Error indicators
	def get_commits_error_indicator
		$driver.find_element(id: ids[:commitlist_no_commits_indicator])
	end

	def has_commits_error_indicator
		get_commits_error_indicator.displayed?
	end

	def get_commits_error
		get_commits_error_indicator.text
	end

	def get_number_of_commits
		$driver.find_elements(name: @screen.ids[:commit_list_list_row]).count
	end
end
