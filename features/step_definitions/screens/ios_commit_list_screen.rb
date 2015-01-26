require_relative 'commit_list_screen'

class IosCommitListScreen < CommitListScreen
	
	def ids
	    map = Hash.new

	    # Commit List Screen
	    map[:commitlist_button_refresh] = 'commitlist_button_refresh'
	    map[:commitlist_list] = 'commitlist_list'
	    map[:commit_list_list_row] = 'commit_list_list_row'
	    map[:commitlist_list_row_label_author] = 'commitlist_list_row_label_author'
	    map[:commitlist_no_commits_indicator] = 'commitlist_no_commits_indicator'
	    map[:commitlist_title] = 'commitlist_title'

	    map
	end
	
end