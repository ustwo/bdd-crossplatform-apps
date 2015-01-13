class CommitListScreen < BaseScreen

	def get_title
		find_element(id: ids.commit_list_screen_title).text
	end
end