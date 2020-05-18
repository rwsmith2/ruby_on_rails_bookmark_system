Feature: view user

Scenario: Go to all users page
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    When I press "View Users" within ".contentSmallForm"
    Then I should be on the all users page
    
Scenario: Search users
    Given I am on the all users page
    When I fill in "search" with "role1"
    When I press "Search" within ".contentSmallForm"
    Then I should see "Logan"
    Then I should not see "Jimmy"
    Then I should not see "James"
    
Scenario: Search but no results
    Given I am on the all users page
    When I fill in "search" with "awe"
    When I press "Search" within ".contentSmallForm"
    Then I should see "Sorry. There is no relevant results."
    Then I should not see "Logan"
    Then I should not see "Jimmy"
    Then I should not see "James"
    
Scenario: Suspend user
    Given I am on the all users page
    When I fill in "search" with "role1"
    When I press "Search" within ".contentSmallForm"
    When I press "Suspend" within ".TableHolder"
    Then I should see "Suspended"
    Then I should not see "Unsuspended"
    
Scenario: UnSuspend user
    Given I am on the all users page
    When I fill in "search" with "role1"
    When I press "Search" within ".contentSmallForm"
    When I press "UnSuspend" within ".TableHolder"
    Then I should see "Unsuspended"
    Then I should not see "Suspend"
    
Scenario: Go to user details page
    Given I am on the all users page
    When I fill in "search" with "role1"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    Then I should be on the user details page
    Then I should see "Details for Logan Miller"
    Then I should see "user_id: 1"
    Then I should see "Email: lmiller6@sheffield.ac.uk"
      
Scenario: Set role
    Given I am on the all users page
    When I fill in "search" with "role3"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    Then I should see "Access Level: registered"
    When I select "A" from "access_level"
    When I press "Save" within ".contentSmallForm"
    Then I should see "Access Level: admin"
    Then I should not see "Access Level: employees"
    Then I should not see "Access Level: registered"
    
Scenario: Reset password but type nothing
    Given I am on the all users page
    When I fill in "search" with "role3"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    When I press "Reset password" within ".contentSmallForm"
    Then I should be on the reset password page
    When I press "Submit" within ".contentSmallForm"
    Then I should see "You should type something before you submit."
    
Scenario: Reset password properly
    Given I am on the all users page
    When I fill in "search" with "role3"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    When I press "Reset password" within ".contentSmallForm"
    Then I should be on the reset password page
    When I fill in "new_password" with "awe"
    When I press "Submit" within ".contentSmallForm"
    Then I should be on the user details page
