 # 
 # The MIT License (MIT)
 # 
 # Copyright (c) 2015 ustwo™
 # 
 # Permission is hereby granted, free of charge, to any person obtaining a copy
 # of this software and associated documentation files (the "Software"), to deal
 # in the Software without restriction, including without limitation the rights
 # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 # copies of the Software, and to permit persons to whom the Software is
 # furnished to do so, subject to the following conditions:

 # The above copyright notice and this permission notice shall be included in all
 # copies or substantial portions of the Software.
 # 
 # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 # SOFTWARE.

require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen

	def get_title
		# Get the ActionBar text - assume its the first TextView in the view hierarchy
		@driver.find_element(class: 'android.widget.TextView').name
	end

	def get_commit index
		text = elements(get_id(:commitlist_row_textview_message))[index].text
		date = elements(get_id(:commitlist_row_textview_date))[index].text

		{text: text, date: date}
	end

	def ids
	{
	    # Commit List Screen
	    commitlist_button_refresh: {id: 'commit_list_button_refresh'},
	    commitlist_no_commits_indicator: {id: 'commit_list_textview_status_information'},
	    commitlist_loading_indicator: {id: 'android:id/progress', is_fully_qualified: true},

	    # Commit List Row
	    commitlist_list_row: {id: 'commit_list_linearlayout_row'},
	    commitlist_row_textview_date: {id: 'commit_list_row_textview_date'},
	    commitlist_row_textview_message: {id: 'commit_list_row_textview_message'},
	    commitlist_list: {id: 'commit_list_listview_commits'}
	}
  end

end