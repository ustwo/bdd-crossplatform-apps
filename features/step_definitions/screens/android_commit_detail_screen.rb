require_relative 'commit_detail_screen'

class AndroidCommitDetailScreen < CommitDetailScreen

	def ids
	{
		commit_detail_root: {id: 'commit_detail_linearlayout_root'},
		commit_detail_loading_indicator: {id: 'android:id/progress', is_fully_qualified: true},

		# Commit information
		commit_detail_textview_name: {id: 'commit_detail_textview_name'},
		commit_detail_textview_email: {id: 'commit_detail_textview_email'},
		commit_detail_textview_date: {id: 'commit_detail_textview_date'},
		commit_detail_textview_message: {id: 'commit_detail_textview_message'}
	}
	end
	
end