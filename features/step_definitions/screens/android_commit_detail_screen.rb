require_relative 'commit_detail_screen'

class AndroidCommitDetailScreen < CommitDetailScreen

	def ids
		map = Hash.new

		map[:commit_detail_root] = {id: 'commit_detail_linearlayout_root', is_fully_qualified: false}
		map[:commit_detail_loading_indicator] = {id: 'android:id/progress', is_fully_qualified: true}

		map[:commit_detail_textview_name] = {id: 'commit_detail_textview_name', is_fully_qualified: false}
		map[:commit_detail_textview_email] = {id: 'commit_detail_textview_email', is_fully_qualified: false}
		map[:commit_detail_textview_date] = {id: 'commit_detail_textview_date', is_fully_qualified: false}
		map[:commit_detail_textview_message] = {id: 'commit_detail_textview_message', is_fully_qualified: false}

		map
	end
	
end