Feature: register

Scenario: Go to register page
    Given I am on the login page
    When I fill in "email" with "lmiller6@sheffield.ac.uk"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "Add Bookmarks" within ".contentSmallForm"
    Then I should be on the adding bookmark page

Scenario: Adding with empty fields
    Given I am on the adding bookmark page
    When I fill in "title" with "Test"
    When I fill in "author" with "Logan Miller"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should see "Please ensure all fields are filled correctly."
    
Scenario: Adding with duplicate title
    Given I am on the adding bookmark page
    When I fill in "title" with "Lab results"
    When I fill in "description" with "Test"
    When I fill in "author" with "Logan Miller"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should see "The title of your bookmark already exists. Please change another one."

Scenario: Proper adding
    Given I am on the login page
    When I fill in "email" with "lmiller6@sheffield.ac.uk"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "Add Bookmarks" within ".contentSmallForm"
    When I fill in "title" with "Test"
    When I fill in "description" with "Test"
    When I fill in "author" with "Logan Miller"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should be on the homepage
    