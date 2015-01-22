require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen
	
	def get_title
		# Get the ActionBar text - assume its the first TextView in the view hierarchy
		$driver.find_element(class: 'android.widget.TextView').name
	end

	def ids
	    map = Hash.new

	    # Commit List Screen
	    map[:commitlist_button_refresh] = 'com.ustwo.sample:id/commit_list_button_refresh'
	    map[:commitlist_no_commits_indicator] = 'com.ustwo.sample:id/commit_list_textview_status_information'
	    map[:commitlist_list] = 'com.ustwo.sample:id/commit_list_listview_commits'

		# Commit Detail Screen
	    map[:commit_detail_textview_name] = 'com.ustwo.sample:id/commit_detail_textview_name'
		map[:commit_detail_textview_email] = 'com.ustwo.sample:id/commit_detail_textview_email'
		map[:commit_detail_textview_date] = 'com.ustwo.sample:id/commit_detail_textview_date'
		map[:commit_detail_textview_message] = 'com.ustwo.sample:id/commit_detail_textview_message'

    	map
  end
	
end