require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen
	
	def get_title
		# Get the ActionBar text - assume its the first TextView in the view hierarchy
		$driver.find_element(class: 'android.widget.TextView').name
	end

	def has_commit_message message
		listview = $driver.find_element(id: ids[:commitlist_list])

		$driver.execute_script("mobile: scrollTo", :element => listview.ref, :text => message)
	end

	def has_date date
		listview = $driver.find_element(id: ids[:commitlist_list])

		$driver.execute_script("mobile: scrollTo", :element => listview.ref, :text => date)
	end

	def ids
	    map = Hash.new

	    # Commit List Screen
	    map[:commitlist_button_refresh] = 'com.ustwo.sample:id/commit_list_button_refresh'
	    map[:commitlist_no_commits_indicator] = 'com.ustwo.sample:id/commit_list_textview_status_information'
	    map[:commitlist_loading_indicator] = 'android:id/progress'

	    # Commit List Row
	    map[:commitlist_row] = 'com.ustwo.sample:id/commit_list_linearlayout_row'
	    map[:commitlist_row_textview_date] = 'com.ustwo.sample:id/commit_list_row_textview_date'
	    map[:commitlist_row_textview_message] = 'com.ustwo.sample:id/commit_list_row_textview_message'
	    map[:commitlist_list] = 'com.ustwo.sample:id/commit_list_listview_commits'
	    map[:commit_list_list_row] = 'com.ustwo.sample:id/commit_list_linearlayout_row'

    	map
  end
	
end