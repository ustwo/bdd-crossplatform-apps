require_relative 'base_screen'

class CommitListScreen < BaseScreen

	def get_title
		get_text(:commitlist_title)
	end

	def has_commit_message message
		listview = $driver.find_element(id: ids[:commitlist_list])

		$driver.execute_script("mobile: scrollTo", :element => listview.ref, :text => message)
	end

	def has_date date
		listview = $driver.find_element(id: ids[:commitlist_list])

		$driver.execute_script("mobile: scrollTo", :element => listview.ref, :text => date)
	end

	def has_no_commits_indicator
		$driver.find_element(id: ids[:commitlist_no_commits_indicator]).displayed?
	end

	def get_text id
		$driver.find_element(id: ids[id]).text
	end
end
