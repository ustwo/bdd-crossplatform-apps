require_relative 'base_screen'

class CommitListScreen < BaseScreen

	# Title
	def get_title
		get_text(ids[:commitlist_title])
	end

	# Loading
	def has_no_commits_indicator
		has_element(ids[:commitlist_no_commits_indicator])
	end

	def has_loading_indicator
		has_element(ids[:commitlist_loading_indicator])
	end

	def has_no_loading_indicator
		has_no_element(ids[:commitlist_loading_indicator])
	end

	# Commit list
	def get_commit index
		raise 'Abstract'
	end

	def get_number_of_commits
		elements_by_text(ids[:commit_list_list_row]).count
	end

	def get_commit_list
		element(ids[:commitlist_list])
	end

	def click_on_commit index
		elements(ids[:commitlist_list_row])[index].click
	end

	# Errors
	def has_error_indicator
		has_element(ids[:commitlist_no_commits_indicator])
	end
	
	def has_commits_error_indicator
		has_element(ids[:commitlist_no_commits_indicator])
	end

	def get_commits_error
		get_text(ids[:commitlist_no_commits_indicator])
	end

	# Public/private repository
	def has_private_repository_indicator
		has_element(get_string_resource('commit_list_repo_private'))
	end

	def has_public_repository_indicator
		has_element(get_string_resource('commit_list_repo_public'))
	end
end
