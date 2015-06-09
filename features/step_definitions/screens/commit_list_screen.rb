require_relative 'base_screen'

class CommitListScreen < BaseScreen

	def wait_for_load
		has_no_loading_indicator
	end

	def get_title
		get_text(get_id(:commitlist_title))
	end

	def has_error_indicator
		has_element(get_id(:commitlist_no_commits_indicator))
	end

	def click_on_commit index
		elements(get_id(:commitlist_list_row))[index].click
	end

	def get_commit index
		raise 'Abstract'
	end

	def has_no_commits_indicator
		has_element(get_id(:commitlist_no_commits_indicator))
	end

	def has_loading_indicator
		has_element(get_id(:commitlist_loading_indicator))
	end

	def has_no_loading_indicator
		has_no_element(get_id(:commitlist_loading_indicator))
	end

	def get_number_of_commits
		elements_by_text(get_id(:commit_list_list_row)).count
	end

	def get_commit_list
		element(get_id(:commitlist_list))
	end

	def has_commits_error_indicator
		has_element(get_id(:commitlist_no_commits_indicator))
	end

	def get_commits_error
		get_text(get_id(:commitlist_no_commits_indicator))
	end

	def has_private_repository_indicator
		has_element(get_string_resource('commit_list_repo_private'))
	end

	def has_public_repository_indicator
		has_element(get_string_resource('commit_list_repo_public'))
	end
end
