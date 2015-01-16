class CommitListScreen < BaseScreen

	def get_title
		get_text(:commitlist_title)
	end

	def has_no_commits_indicator
		!$driver.find_element(id: ids[:commitlist_no_commits_indicator]).nil?
	end

	def get_text id
		$driver.find_element(id: ids[id]).text
	end
end
