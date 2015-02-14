require_relative 'base_screen'

class CommitListScreen < BaseScreen

	def wait_for_load
		has_no_loading_indicator
	end

	def get_title
		get_text('commitlist_title')
	end

	def has_error_indicator
		has_element('commitlist_no_commits_indicator')
	end

	def click_on_commit index
		elements('commit_list_list_row')[index].click
	end

	def get_commit index
		raise 'Abstract'
	end

	def has_no_commits_indicator
		has_element('commitlist_no_commits_indicator')
	end

	def has_loading_indicator
		has_element('commit_list_loading_indicator')
	end

	def has_no_loading_indicator
		has_no_element('commit_list_loading_indicator')
	end

	def get_number_of_commits
		elements_by_text('commitlist_list_row').count
	end

	def get_commit_list
		element('commitlist_list')
	end

	def has_commits_error_indicator
		has_element('commitlist_no_commits_indicator')
	end

	def get_commits_error
		get_text('commitlist_no_commits_indicator')
	end
end
