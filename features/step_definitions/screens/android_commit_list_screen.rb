require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen

	def get_title
		# Get the ActionBar text - assume its the first TextView in the view hierarchy
		@driver.find_element(class: 'android.widget.TextView').name
	end

	def get_commit index
		text = elements(get_id(:commitlist_row_textview_message))[index].text
		date = elements(get_id(:commitlist_row_textview_date))[index].text

		{text: text, date: date}
	end

	def ids
	{
	    # Commit List Screen
	    commitlist_button_refresh: {id: 'commit_list_button_refresh'},
	    commitlist_no_commits_indicator: {id: 'commit_list_textview_status_information'},
	    commitlist_loading_indicator: {id: 'android:id/progress', is_fully_qualified: true},

	    # Commit List Row
	    commitlist_list_row: {id: 'commit_list_linearlayout_row'},
	    commitlist_row_textview_date: {id: 'commit_list_row_textview_date'},
	    commitlist_row_textview_message: {id: 'commit_list_row_textview_message'},
	    commitlist_list: {id: 'commit_list_listview_commits'}
	}
  end

end