require_relative 'commit_list_screen'

class IosCommitListScreen < CommitListScreen

	def get_commit index
		text = @driver.find_element(xpath: "//UIATableCell[#{index+1}]/UIAStaticText[1]").text
		date = @driver.find_element(xpath: "//UIATableCell[#{index+1}]/UIAStaticText[2]").text

		{text: text, date: date}
	end

end
