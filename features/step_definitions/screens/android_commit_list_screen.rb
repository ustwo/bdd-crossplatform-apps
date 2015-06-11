/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 ustwo™
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

require_relative 'commit_list_screen'

class AndroidCommitListScreen < CommitListScreen

	def get_title
		# Get the ActionBar text - assume its the first TextView in the view hierarchy
		@driver.find_element(class: 'android.widget.TextView').name
	end

	def get_commit index
		text = @driver.find_elements(id: "com.ustwo.sample:id/commit_list_row_textview_message")[index].text
		date = @driver.find_elements(id: "com.ustwo.sample:id/commit_list_row_textview_date")[index].text

		{text: text, date: date}
	end

	def ids
	    map = Hash.new

	    # Commit List Screen
	    map[:commitlist_button_refresh] = 'com.ustwo.sample:id/commit_list_button_refresh'
	    map[:commitlist_no_commits_indicator] = 'com.ustwo.sample:id/commit_list_textview_status_information'
	    map[:commitlist_loading_indicator] = 'android:id/progress'

	    # Commit List Row
	    map[:commitlist_list_row] = 'com.ustwo.sample:id/commit_list_linearlayout_row'
	    map[:commitlist_row_textview_date] = 'com.ustwo.sample:id/commit_list_row_textview_date'
	    map[:commitlist_row_textview_message] = 'com.ustwo.sample:id/commit_list_row_textview_message'
	    map[:commitlist_list] = 'com.ustwo.sample:id/commit_list_listview_commits'

    	map
  end

end
