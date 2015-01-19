require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen
	
	def get_title
		# Get the ActionBar text - assume its the first TextView in the view hierarchy
		$driver.find_element(class: 'android.widget.TextView').name
	end
	
end