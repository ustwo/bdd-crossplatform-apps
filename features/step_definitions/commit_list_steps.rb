require_relative '../support/mock_backend/mock_backend'

Given(/^I am on the commit list screen$/) do
  @screen = launch_to_commit_list_screen
end

Then(/^I should be able to see the repository title$/) do
  repo_json = GitHubMockBackend::API.get_repo_json()
  expected_title = repo_json['name']
  actual_title = @screen.get_title

  expect(actual_title).to eq(expected_title)
end

Then(/^I should be able to see the latest 10 commits$/) do
  commits_json = GitHubMockBackend::API.get_commits_json()
  expected_number_of_commits = commits_json.count
  actual_number_of_commits = @screen.get_number_of_commits

  expect(actual_number_of_commits).to eq(expected_number_of_commits)
end

Then(/^I should see the commit message and date of each commit$/) do
  json = GitHubMockBackend::API.get_commits_json()

  json.each do |commit|
    expected_message = commit['commit']['message']
    expected_date = commit['commit']['author']['date']

    expect(@screen.has_commit_message(expected_message)).to be(true), "Expected message '#{expected_message}' was not found in the list of commits"
    expect(@screen.has_date(expected_date)).to be(true), "Expected date '#{expected_date}' was not found in the list of commits"
  end
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
  expect(@screen.has_commits_error_indicator).to be(true), "Expected commit error indicator is displayed"

  no_commits_available_text = 'No commits available'
  expect(@screen.get_commits_error).to eq(no_commits_available_text), "Expected commit error indicator displaying message #{no_commits_available_text}"
end

When(/^one of the commits has a message that doesn't fit in one line$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^it should be cut off and ellipses added$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^there is a server error retriving data$/) do
  GitHubMockBackend::API.set_error_json('commits_error', 405)
end

Then(/^I should see an indicator of server error$/) do
  expect(@screen.has_commits_error_indicator).to be(true), "Expected commit error indicator is displayed"

  could_not_load_commits_text = 'Could not load commits'
  expect(@screen.get_commits_error).to eq(could_not_load_commits_text), "Expected commit error indicator displaying message #{could_not_load_commits_text}"
end

Given(/^the server times out when requesting data$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see an indicator slow server$/) do
  pending # express the regexp above with the code you wish you had
end
