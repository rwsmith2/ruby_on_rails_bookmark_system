Feature: request

Scenario: Go to the create request page for to reset password
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "pass word"
    When I press "Login" within ".contentSmallForm"
    Then I should see "Invalid Username or Password. Please try again."
    When I press "Request" within ".contentSmallForm"
    Then I should be on the create request page.
    
Scenario: Go to the create request page for to ask for unsuspend
    Given I am on the login page
    When I fill in "username" with "role3"
    When I fill in "password" with "CAPITALlower314"
    When I press "Login" within ".contentSmallForm"
    Then I should see "Your account has been suspended. Please contact admin."
    When I press "Contact" within ".contentSmallForm"
    Then I should be on the create request page.
    
Scenario: create a request properly
    Given I am on the create request page
    When I fill in "username" with "role1"
    When I fill in "content" with "change the password"
    When I press "Submit" within ".contentSmallForm"
    Then I should be on the login page.
    
Scenario: create a request with empty fields
    Given I am on the create request page
    When I fill in "content" with "change the password"
    When I press "Submit" within ".contentSmallForm"
    Then I should see "Please ensure all fields are filled correctly."
    
Scenario: create a request with non-existence username
    Given I am on the create request page
    When I fill in "username" with "my account"
    When I fill in "content" with "change the password"
    When I press "Submit" within ".contentSmallForm"
    Then I should see "The username does not exist, please type the right one."
    
Scenario: Go to the view request page
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View Request" within ".contentSmallForm"
    Then I should be on the view request page

Scenario: Mark request as read
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View Request" within ".contentSmallForm"
    When I press "Mark as read"
    Then I should see "Read" within ".r"

Scenario: Mark request as unread
    Given I am on the login page
    When I fill in "username" with "role1"
    When I fill in "password" with "password"
    When I press "Login" within ".contentSmallForm"
    When I press "View Request" within ".contentSmallForm"
    When I press "Mark as unread"
    Then I should see "Unread" within ".r"
