# Scenarios go here!
Feature: login

Scenario: Go to login page
    Given I am on the homepage
    When I press "Log In" within ".contentSmallForm"
    Then I should be on the login page
   
Scenario: Correct email and password
    Given I am on the login page
    When I fill in "email" with "lmiller6@sheffield.ac.uk"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    Then I should be on the homepage
    Then I should not see "View as a guest"
   
Scenario: Wrong or empty email 
    Given I am on the login page
    When I fill in "email" with "lmiller@sheffield.ac.uk"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    Then I should see "Invalid Username or Password. Please try again."
    
Scenario: Wrong or empty password 
    Given I am on the login page
    When I fill in "email" with "lmiller6@sheffield.ac.uk"
    When I fill in "password" with "pass word"
    When I press "Login" within ".contentSmallForm"
    Then I should see "Invalid Username or Password. Please try again."
    
Scenario: Logout
    Given I am on the login page
    When I fill in "email" with "lmiller6@sheffield.ac.uk"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    Then I should be on the homepage
    When I follow "Log Out" 
    Then I should be on the logout page
    Then I should see "You have succesfully logged out."
    Then I should see "Thank you for using Bookmark Manager"