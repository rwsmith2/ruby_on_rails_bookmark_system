Feature: register

Scenario: Go to register page
    Given I am on the homepage
    When I press "Register" within ".contentSmallForm"
    Then I should be on the register page
    
Scenario: Proper registration
    Given I am on the register page
    When I fill in "firstname" with "Some"
    When I fill in "surname" with "Guy"
    When I fill in "username" with "role7"
    When I fill in "email" with "someguy@sheffield.ac.uk"
    When I fill in "phone_number" with "42424"
    When I fill in "password" with "password"
    When I fill in "confirm_password" with "password"
    When I press "Register" within ".contentSmallForm"
    Then I should be on the homepage
    Then I should see "View as a guest"
    
Scenario: Duplicate username
    Given I am on the register page
    When I fill in "firstname" with "Some"
    When I fill in "surname" with "Guy"
    When I fill in "username" with "role7"
    When I fill in "email" with "someguy2@sheffield.ac.uk"
    When I fill in "phone_number" with "42424"
    When I fill in "password" with "password"
    When I fill in "confirm_password" with "password"
    When I press "Register" within ".contentSmallForm"
    Then I should be on the register page
    Then I should see "Your Username has been taken. Please use another one."
   
Scenario: Invalid email address
    Given I am on the register page
    When I fill in "firstname" with "Some"
    When I fill in "surname" with "Guy"
    When I fill in "username" with "role9"
    When I fill in "email" with "someguysheffield.ac.uk"
    When I fill in "phone_number" with "42424"
    When I fill in "password" with "password"
    When I fill in "confirm_password" with "password"
    When I press "Register" within ".contentSmallForm"
    Then I should be on the register page
    Then I should see "Your email address is invalid. Please change it."
    
Scenario: Empty fields
    Given I am on the register page
    When I fill in "firstname" with "Some"
    When I fill in "surname" with "Guy"
    When I fill in "username" with "role7"
    When I fill in "email" with "someguy1@sheffield.ac.uk"
    When I fill in "password" with "password"
    When I fill in "confirm_password" with "password"
    When I press "Register" within ".contentSmallForm"
    Then I should be on the register page
    Then I should see "Please ensure all fields are filled correctly."
    
Scenario: Password and confirm_password are not the same
    Given I am on the register page
    When I fill in "firstname" with "Some"
    When I fill in "surname" with "Guy"
    When I fill in "username" with "role7"
    When I fill in "email" with "someguy2@sheffield.ac.uk"
    When I fill in "phone_number" with "42424"
    When I fill in "password" with "password"
    When I fill in "confirm_password" with "password1"
    When I press "Register" within ".contentSmallForm"
    Then I should be on the register page
    Then I should see "The 'Password' and 'Confirm Password' are not the same"
    

      
