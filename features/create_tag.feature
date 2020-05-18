Feature: create tag

Scenario: Go to create tag page
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    When I press "Create Tag" within ".contentSmallForm"
    Then I should be on the create tag page
    
Scenario: Type nothing
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    When I press "Create Tag" within ".contentSmallForm"
    When I press "Create" within ".contentSmallForm"
    Then I should see "You should type something before you submit."
    
Scenario: Create duplicated tag
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    When I press "Create Tag" within ".contentSmallForm"
    When I fill in "tag" with "Lab"
    When I press "Create" within ".contentSmallForm"
    Then I should see "The tag you want to create already exists. Please change a new one."
    
Scenario: Create tag properly
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    When I press "Create Tag" within ".contentSmallForm"
    When I fill in "tag" with "Sport"
    When I press "Create" within ".contentSmallForm"
    Then I should be on the homepage