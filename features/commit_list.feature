Feature: display list of commits

  @test
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
    Given the server is slow responding with data
    And I am on the commit list screen before data has loaded
    Then I should see a loading indicator until reponse has been received

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

  @ios-not-ready
  Scenario: private repository
    Given the repository is private
    Given I am on the commit list screen
    Then I should see a private repository indicator

  @ios-not-ready
  Scenario: public repository
    Given the repository is public
    Given I am on the commit list screen
    Then I should see a public repository indicator
