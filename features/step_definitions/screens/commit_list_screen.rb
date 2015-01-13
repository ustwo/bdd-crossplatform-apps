class CommitListScreen < BaseScreen

	def get_title
		commitlist_header_title.text
	end

	def commitlist_header_title
		return $driver.find_element(id: ids[:commitlist_header_title])
	end
end