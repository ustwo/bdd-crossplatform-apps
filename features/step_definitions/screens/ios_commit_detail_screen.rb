require_relative 'commit_detail_screen'

class IosCommitDetailScreen < CommitDetailScreen
	
	def ids

	    map = Hash.new
	    map[:commitlist_button_refresh] = 'commitlist_button_refresh'
	    map[:commitlist_list_row_label_author] = 'commitlist_list_row_label_author'
	    map[:commitlist_no_commits_indicator] = 'commitlist_no_commits_indicator'
	    map[:commitlist_title] = 'commitlist_title'

	    map
	end
	
end