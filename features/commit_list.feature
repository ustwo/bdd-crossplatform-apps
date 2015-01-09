Feature: display list of commits

  Background:
    Given I am on the commit list screen

  Scenario: display repository title
    Then I should be able to see the repository title

  Scenario: display latest commits
    Then I should be able to see the latest 20 commits

  # Question, do we define the date format in here?
  Scenario: per-commit information
    Then I should see the commit message and date of each commit

  Scenario: go to commit details
    When I choose to see the details of a specific commit
    Then I should be taken to the commit details screen

  # UI scenarios below

  Scenario: display loading indicator
    When data is loading
    Then I should see a loading indicator

  Scenario: repository has no commits
    And the repository has no commits
    Then I should see an indicator of no commits

  Scenario: commit message is too long
    When one of the commits has a message that doesn't fit in one line
    Then it should be cut off and ellipses added

  Scenario: server error
    And there is a server error retriving data
    Then I should see an indicator of server error

  Scenario: client-side time out
    And the server times out when requesting data
    Then I should see an indicator slow server

  Scenario: broken JSON
