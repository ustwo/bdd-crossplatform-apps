require_relative '../support/mock_backend/utils'

Given(/^I am on the commit list screen$/) do
  @screen = launch_to_commit_list_screen
end

Then(/^I should be able to see the repository title$/) do
  json = GitHubMockBackend::API.get_repo_json()

  expected_title = json['name']
  actual_title = @screen.get_title

  expect(actual_title).to eq(expected_title)
end

Then(/^I should be able to see the latest 10 commits$/) do
  step 'I should see the commit message and date of each commit'
end

Then(/^I should see the commit message and date of each commit$/) do
  commits_json = GitHubMockBackend::API.get_commits_json()

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
  GitHubMockBackend::API.set_request_delay(3)
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
  GitHubMockBackend::API.set_commits_json('no_commits_repo')
end

Then(/^I should see an indicator of no commits$/) do
  expect(@screen.has_commits_error_indicator).to be(true), "Expected commit error indicator is displayed"
end

When(/^one of the commits has a message that doesn't fit in one line$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^it should be cut off and ellipses added$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^there is a server error retriving data$/) do
  GitHubMockBackend::API.set_response body: GitHubMockBackend::Utils.file_content('commits_error'), status: 405
end

Given(/^the json retrieved from the server is broken$/) do
  GitHubMockBackend::API.set_response body: GitHubMockBackend::Utils.file_content('broken_json')
end

Then(/^I should see an indicator of server error$/) do
  expect(@screen.has_commits_error_indicator).to be(true), "Expected commit error indicator is displayed"
end

Given(/^the server times out when requesting data$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see an indicator slow server$/) do
  pending # express the regexp above with the code you wish you had
end
