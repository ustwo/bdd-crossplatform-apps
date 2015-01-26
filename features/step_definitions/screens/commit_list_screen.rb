require_relative 'base_screen'

class CommitListScreen < BaseScreen

	def get_title
		get_text(:commitlist_title)
	end

	def click_on_commit index
		$driver.find_elements(id: ids[:commitlist_row])[index].click
	end

	def has_no_commits_indicator
		$driver.find_element(id: ids[:commitlist_no_commits_indicator]).displayed?
	end

	def loading_indicator_visible
		begin
			# if we can't find the loading indicator, it's not visible
			$driver.find_element(id: ids[:commitlist_loading_indicator]).displayed?
		rescue
			false
		end
	end

	def get_text id
		$driver.find_element(id: ids[id]).text
	end
end
