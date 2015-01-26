require_relative '../support/mock_backend/mock_backend'

Given(/^I am on the commit list screen$/) do
  @screen = launch_to_commit_list_screen
end

Then(/^I should be able to see the repository title$/) do
  expected_title = GitHubMockBackend::API.get_repo_json()['name']
  actual_title = @screen.get_title

  expect(actual_title).to eq(expected_title)
end

Then(/^I should be able to see the latest (\d+) commits$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the commit message and date of each commit$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I choose to see the details of a specific commit$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be taken to the commit details screen$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^data is loading$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a loading indicator$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^the repository has no commits$/) do
  GitHubMockBackend::API.set_commits_json('no_commits_repo')
end

Then(/^I should see an indicator of no commits$/) do
  expect(@screen.has_no_commits_indicator).to be true
end

When(/^one of the commits has a message that doesn't fit in one line$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^it should be cut off and ellipses added$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^there is a server error retriving data$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^the json retrieved from the server is broken$/) do
  GitHubMockBackend::API.set_commits_json('broken_json')
end

Then(/^I should see an indicator of server error$/) do
  expect(@screen.has_error_indicator).to be true
end

Given(/^the server times out when requesting data$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see an indicator slow server$/) do
  pending # express the regexp above with the code you wish you had
end