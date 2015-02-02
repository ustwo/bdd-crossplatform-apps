Feature: display list of commits


  Scenario: display repository title
    Given I am on the commit list screen
    Then I should be able to see the repository title

  Scenario: display latest commits
    Given I am on the commit list screen
    Then I should be able to see the latest 10 commits

  Scenario: per-commit information
    Given I am on the commit list screen
    Then I should see the commit message and date of each commit

  Scenario: go to commit details
    Given I am on the commit list screen
    When I choose to see the details of a specific commit
    Then I should be taken to the commit details screen

  # UI scenarios below

  Scenario: display loading indicator
    Given I am on the commit list screen
    When data is loading
    Then I should see a loading indicator

  Scenario: repository has no commits
    Given the repository has no commits
    And I am on the commit list screen
    Then I should see an indicator of no commits

  Scenario: commit message is too long
    Given one of the commits has a message that doesn't fit in one line
    When I am on the commit list screen
    Then it should be cut off and ellipses added

  Scenario: server error
    Given there is a server error retriving data
    When I am on the commit list screen
    Then I should see an indicator of server error

  Scenario: client-side time out
    Given the server times out when requesting data
    When I am on the commit list screen
    Then I should see an indicator slow server

  Scenario: broken JSON
    Given the json retrieved from the server is broken
    Given I am on the commit list screen
    Then I should see an indicator of server error
