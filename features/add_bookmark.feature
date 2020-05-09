Feature: add bookmark

Scenario: Go to adding bookmark page
    Given I am on the login page
    When I fill in "username" with "role2"
    When I fill in "password" with "pWORD1"
    When I press "Login" within ".contentSmallForm"
    When I press "Add Bookmarks" within ".contentSmallForm"
    Then I should be on the adding bookmark page

Scenario: Adding with empty fields
    Given I am on the adding bookmark page
    When I fill in "title" with "Test"
    When I fill in "author" with "James Acaster"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should see "Please ensure all fields are filled correctly."
    
Scenario: Adding with duplicate title
    Given I am on the adding bookmark page
    When I fill in "title" with "Lab results"
    When I fill in "description" with "Test"
    When I fill in "author" with "James Acaster"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should see "The title of your bookmark already exists. Please change another one."

Scenario: Proper adding without tags
    Given I am on the login page
    When I fill in "username" with "role2"
    When I fill in "password" with "pWORD1"
    When I press "Login" within ".contentSmallForm"
    When I press "Add Bookmarks" within ".contentSmallForm"
    When I fill in "title" with "Test"
    When I fill in "description" with "Test"
    When I fill in "author" with "James Acaster"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should be on the homepage

Scenario: Proper adding with tags
    Given I am on the login page
    When I fill in "username" with "role2"
    When I fill in "password" with "pWORD1"
    When I press "Login" within ".contentSmallForm"
    When I press "Add Bookmarks" within ".contentSmallForm"
    When I fill in "title" with "Test1"
    When I fill in "description" with "Test1"
    When I fill in "author" with "James Acaster"
    When I select "Lab" from "select_tag1"
    When I select "Website" from "select_tag2"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should be on the homepage

Scenario: adding with duplicated tags
    Given I am on the login page
    When I fill in "username" with "role2"
    When I fill in "password" with "pWORD1"
    When I press "Login" within ".contentSmallForm"
    When I press "Add Bookmarks" within ".contentSmallForm"
    When I fill in "title" with "Test2"
    When I fill in "description" with "Test2"
    When I fill in "author" with "James Acaster"
    When I select "Lab" from "select_tag1"
    When I select "Lab" from "select_tag2"
    When I fill in "content" with "Just a Test"
    When I press "Add" within ".contentSmallForm"
    Then I should see "The bookmark contains duplicated tags. Please change them to unique."
