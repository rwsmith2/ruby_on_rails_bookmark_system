Feature: view bookmark

Scenario: Go to view bookmark page
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View All Bookmarks" within ".contentSmallForm"
    Then I should be on the view bookmark page
    
Scenario: Search bookmarks by title
    Given I am on the view bookmark page
    When I fill in "search" with "Funny"
    When I press "Search" within ".contentSmallForm"
    Then I should see "Funny jokes"
    Then I should not see "My website"
    Then I should not see "Lab results"
    
Scenario: Search but no results
    Given I am on the view bookmark page
    When I fill in "search" with "awe"
    When I press "Search" within ".contentSmallForm"
    Then I should see "Sorry. There is no relevant results."
    Then I should not see "Lab results"
    Then I should not see "My website"
    Then I should not see "Funny jokes"
    
Scenario: Filter by rate
    Given I am on the view bookmark page
    When I select "R" from "filter"
    When I press "Filter" within ".contentSmallForm"
    Then I should see "Now Order By Rate"
    
Scenario: Filter by date
    Given I am on the view bookmark page
    When I select "D" from "filter"
    When I press "Filter" within ".contentSmallForm"
    Then I should see "Now Order By Date"
    
Scenario: Search first then filter by rate
    Given I am on the view bookmark page
    When I fill in "search" with "Funny"
    When I press "Search" within ".contentSmallForm"
    When I select "R" from "filter"
    When I press "Filter" within ".contentSmallForm"
    Then I should see "Now Order By Rate"

Scenario: Search first then filter by Date
    Given I am on the view bookmark page
    When I fill in "search" with "Funny"
    When I press "Search" within ".contentSmallForm"
    When I select "D" from "filter"
    When I press "Filter" within ".contentSmallForm"
    Then I should see "Now Order By Date"
    
Scenario: Report bookmark
    Given I am on the view bookmark page
    When I fill in "search" with "Lab"
    When I press "Search" within ".contentSmallForm"
    When I press "Report" within ".TableHolder"
    Then I should see "Has Been Reported"
    Then I should not see "Not Reported"
    
Scenario: Unreport bookmark
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View All Bookmarks" within ".contentSmallForm"
    When I fill in "search" with "Lab"
    When I press "Search" within ".contentSmallForm"
    When I press "Unreport" within ".TableHolder"
    Then I should see "Not Reported"
    Then I should not see "Has Been Reported"
    
Scenario: Go to bookmark details page
    Given I am on the view bookmark page
    When I fill in "search" with "Funny"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    Then I should be on the bookmark details page
    Then I should see "Title: Funny jokes"
    Then I should see "Description: Top 100 jokes"
    Then I should see "Creating Date: 2019-12-9"

Scenario: Rate bookmark
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View All Bookmarks" within ".contentSmallForm"
    When I fill in "search" with "Funny"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    Then I should see "Rateing: Not Rated"
    When I select "5" from "rating_points"
    When I press "Rate" within ".contentSmallForm"
    Then I should not see "Rating: Not Rated"
    Then I should see "Rating: 5"
  
Scenario: Rate your own bookmark
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View All Bookmarks" within ".contentSmallForm"
    When I fill in "search" with "Lab"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    When I select "5" from "rating_points"
    When I press "Rate" within ".contentSmallForm"
    Then I should see "Sorry. You can't rate the bookmark created by you."
    
Scenario: Delete bookmark
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View All Bookmarks" within ".contentSmallForm"
    When I fill in "search" with "Funny"
    When I press "Search" within ".contentSmallForm"
    When I press "Details" within ".TableHolder"
    When I press "Delete" within ".contentSmallForm"
    Then I should be on the view bookmark page
    Then I should not see "Funny jokes"
    
#search by tags
#comment