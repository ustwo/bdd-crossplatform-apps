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

require_relative 'base_screen'

class CommitListScreen < BaseScreen

	# Title
	def get_title
		get_text(get_id(:commitlist_title))
	end

	# Loading
	def has_no_commits_indicator
		has_element(get_id(:commitlist_no_commits_indicator))
	end

	def has_loading_indicator
		has_element(get_id(:commitlist_loading_indicator))
	end

	def has_no_loading_indicator
		has_no_element(get_id(:commitlist_loading_indicator))
	end

	# Commit list
	def get_commit index
		raise 'Abstract'
	end

	def get_number_of_commits
		elements_by_text(get_id(:commit_list_list_row)).count
	end

	def get_commit_list
		element(get_id(:commitlist_list))
	end

	def click_on_commit index
		elements(get_id(:commitlist_list_row))[index].click
	end

	# Errors
	def has_error_indicator
		has_element(get_id(:commitlist_no_commits_indicator))
	end

	def has_commits_error_indicator
		has_element(get_id(:commitlist_no_commits_indicator))
	end

	def get_commits_error
		get_text(get_id(:commitlist_no_commits_indicator))
	end

	# Public/private repository
	def has_private_repository_indicator
		has_element(get_string_resource('commit_list_repo_private'))
	end

	def has_public_repository_indicator
		has_element(get_string_resource('commit_list_repo_public'))
	end
end