require_relative 'commit_detail_screen'

class IosCommitDetailScreen < CommitDetailScreen
	
	def ids
	    map = Hash.new
		map[:commit_detail_root] = 'commit_detail_view'

	    map
	end
	
end