require_relative 'commit_list_screen'

class IosCommitListScreen < CommitListScreen

	def get_commit index
		text = @driver.find_element(xpath: "//UIATableCell[#{index+1}]/UIAStaticText[1]").text
		date = @driver.find_element(xpath: "//UIATableCell[#{index+1}]/UIAStaticText[2]").text

		{text: text, date: date}
	end

	def ids
	{
	  commitlist_button_refresh: 'commitlist_button_refresh',
	  commitlist_list: 'commitlist_list',
	  commitlist_list_row: 'commit_list_list_row',
	  commitlist_list_row_label_author: 'commitlist_list_row_label_author',
	  commitlist_no_commits_indicator: 'commitlist_no_commits_indicator',
	  commitlist_title: 'commitlist_title',
	  commitlist_loading_indicator: 'commit_list_loading_indicator'
	}
	end

end
