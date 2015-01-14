class CommitListScreen < BaseScreen

	def get_title
		get_text(:commitlist_title)
	end

	def get_text id
		$driver.find_element(id: ids[id]).text
	end
end
