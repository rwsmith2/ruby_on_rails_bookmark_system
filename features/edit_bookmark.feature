Feature: edit bookmark

Scenario: Go to my bookmark page
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    When I press "View My Bookmark" within ".contentSmallForm"
    Then I should be on the my bookmark page

Scenario: Go to edit bookmark page
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    Given I am on the my bookmark page
    When I press "Edit" within ".TableHolder"
    Then I should be on the edit bookmark page
    Then the "title" field should contain "Lab results"
    Then the "author" field should contain "Logan Miller"
    Then the "description" field should contain "Details of february's lab"
    Then the "content" field should contain "/lab.html"

Scenario: Edit bookmark with empty fieads
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    Given I am on the my bookmark page
    When I press "Edit" within ".TableHolder"
    When I fill in "title" with ""
    When I press "Save" within ".contentSmallForm"   
    Then I should see "Please ensure all fields are filled correctly."
 
    
Scenario: Edit bookmark with duplicate title
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    Given I am on the my bookmark page
    When I press "Edit" within ".TableHolder"
    When I fill in "title" with "My website"
    When I press "Save" within ".contentSmallForm"
    Then I should see "The title of your bookmark already exists. Please change another one"

Scenario: Edit bookmark with duplicate tags
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    Given I am on the my bookmark page
    When I press "Edit" within ".TableHolder"
    When I select "Lab" from "select_tag2"
    When I press "Save" within ".contentSmallForm"
    Then I should see "The bookmark contains duplicated tags. Please change them to unique."
 
Scenario: Edit bookmark without changing
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    Given I am on the my bookmark page
    When I press "Edit" within ".TableHolder"
    When I press "Save" within ".contentSmallForm"
    Then I should see "You need to change something"
    
Scenario: Proper edit(with or without tag)
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "role1"
    When I press "Login" within ".contentSmallForm"
    Given I am on the my bookmark page
    When I press "Edit" within ".TableHolder"
    When I fill in "title" with "Labs"
    When I select "Website" from "select_tag2"
    When I press "Save" within ".contentSmallForm"
    Then I should be on the my bookmark page
    Then I should see "Labs"
    Then I should not see "Lab results"
