require_relative 'base_screen'

class CommitDetailScreen < BaseScreen

	def is_on_commit_detail_screen
		has_element(ids[:commit_detail_root])
	end

end
