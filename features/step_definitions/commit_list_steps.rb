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

require_relative '../support/mock_backend/utils'
include GitHubMockBackend

SERVER_TIME_OUT_DELAY = 61

Given(/^I am on the commit list screen$/) do
  @screen = launch_to_commit_list_screen
end

Then(/^I should be able to see the repository title$/) do
  json = API.get_repo_json()

  expected_title = json['name']
  actual_title = @screen.get_title

  expect(actual_title).to eq(expected_title)
end

Then(/^I should be able to see the latest 10 commits$/) do
  step 'I should see the commit message and date of each commit'
end

Then(/^I should see the commit message and date of each commit$/) do
  commits_json = API.get_commits_json()

  # See: https://github.com/ustwo/bdd-crossplatform-apps/issues/38
  6.times do |index|

    commit_json = commits_json[index]
    expected_message = commit_json['commit']['message']
    expected_date = commit_json['commit']['author']['date']

    actual_commit = @screen.get_commit(index)

    expect(actual_commit[:text]).to eq(expected_message), "Expected message for commit ##{index} is '#{expected_message}', found '#{actual_commit[:text]}' instead"
    expect(actual_commit[:date]).to eq(expected_date), "Expected date for commit ##{index} is #{expected_date}, found #{actual_commit[:date]} instead"
  end
end

When(/^I choose to see the details of a specific commit$/) do
  @screen.click_on_commit(2)
  @detail_screen = get_commit_detail_screen
  @detail_screen.wait_for_load
end

Then(/^I should be taken to the commit details screen$/) do
  expect(is_on_screen(@detail_screen)).to be true
end

Given(/^the server is slow responding with data$/) do
  API.set_request_delay(delay: 3)
end

And(/^I am on the commit list screen before data has loaded/) do
  @screen = launch_to_commit_list_screen(wait_for_load: false)
end

Then(/^I should see a loading indicator until reponse has been received$/) do
  expect(@screen.has_loading_indicator).to be true
  @screen.wait_for_load
  expect(@screen.has_no_loading_indicator).to be true
end

Given(/^the repository has no commits$/) do
  API.set_commits_json(file_name: 'no_commits_repo')
end

Then(/^I should see an indicator of no commits$/) do
  expect(@screen.has_commits_error_indicator).to be(true), "Expected commit error indicator is displayed"
end

Given(/^there is a server error retriving data$/) do
  API.set_repo_json(file_name: 'commits_error')
  API.set_commits_json(file_name: 'commits_error')
  API.set_response(status: 405)
end

Given(/^the json retrieved from the server is broken$/) do
  API.set_response body: Utils.file_content(file_name: 'broken_json')
end

Then(/^I should see an indicator of server error$/) do
  sleep SERVER_TIME_OUT_DELAY
  expect(@screen.has_commits_error_indicator).to be(true), "Expected commit error indicator is displayed"
end

Given(/^the server times out when requesting data$/) do
  API.set_request_delay(delay: SERVER_TIME_OUT_DELAY)
end

Given(/^the repository is private$/) do
  API.set_repo_json(file_name: 'private_repo')
end

Then(/^I should see a private repository indicator$/) do
  expect(@screen.has_private_repository_indicator).to be(true)
end

Given(/^the repository is public$/) do
  API.set_repo_json(file_name: 'public_repo')
end

Then(/^I should see a public repository indicator$/) do
  expect(@screen.has_public_repository_indicator).to be(true)
end
