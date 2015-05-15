require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen

	def get_title
		# Get the ActionBar text - assume its the first TextView in the view hierarchy
		@driver.find_element(class: 'android.widget.TextView').name
	end

	def get_commit index
		text = @driver.find_elements(id: 'commitlist_list_row_label_message')[index].text
		date = @driver.find_elements(id: 'commitlist_list_row_label_date')[index].text

		{text: text, date: date}
	end

end
