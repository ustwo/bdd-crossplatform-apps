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

require_relative 'commit_detail_screen'

class AndroidCommitDetailScreen < CommitDetailScreen

	def ids
	{
		commit_detail_root: {id: 'commit_detail_linearlayout_root'},
		commit_detail_loading_indicator: {id: 'android:id/progress', is_fully_qualified: true},

		# Commit information
		commit_detail_textview_name: {id: 'commit_detail_textview_name'},
		commit_detail_textview_email: {id: 'commit_detail_textview_email'},
		commit_detail_textview_date: {id: 'commit_detail_textview_date'},
		commit_detail_textview_message: {id: 'commit_detail_textview_message'}
	}
	end

end
