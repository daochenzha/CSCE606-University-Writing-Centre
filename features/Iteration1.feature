Feature: Create new tasks and Editing the tasks



Background: I logged in as "amithmurakonda@gmail.com"

    Scenario: create task
    Given a user
    When I am on "login" users page
    And I fill in "Email" with "amithmurakonda@gmail.com"
    And I fill in "Password" with "amith123"
    And I press "Login"
    Then I should be redirected to "users" page
    And I press "New Task"
    Then I should be on "new task" page
