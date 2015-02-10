require_relative 'base_screen'

class CommitDetailScreen < BaseScreen

	def is_on_commit_detail_screen
		is_on_screen ids[:commit_detail_root]
	end

end
