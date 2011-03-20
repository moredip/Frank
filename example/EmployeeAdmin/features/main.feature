Feature: Demonstrating using Frank to test the EmployeeAdmin example app

Background:
    Given I launch the app 

Scenario: Add test user
    When I touch the Add User button
    And I fill in text fields as follows:
      | field      | text   |
      | First Name | Brian  |
      | Last Name  | Knorr  |
      | Email      | a@b.c  |
      | Username   | bknorr |
      | Password   | 123    |
      | Confirm    | 123    |
    And I touch "Save"
    Then I should be on the Users screen
    And I should see a table containing "Brian Knorr" 

Scenario: default users should be present after app startup
    Then I should be on the Users screen 
    And I should see a table containing the following:
      | Larry Stooge |
      | Curly Stooge |
      | Moe Stooge   |

Scenario: attempting to a new user without supplying any input
    When I touch the Add User button
    And I wait to see a navigation bar titled "User Profile"
    And I touch the "Save" nav bar button
    Then I should see an alert view saying "Invalid User"

Scenario: Updating a user profile
    Given test user Brian is present
    When I touch "Brian Knorr"
    And I fill in text fields as follows:
      | field      | text    |
      | First Name | Jack    |
      | Last Name  | Dempsey |
    And I touch "Save"
    Then I should not see an alert view
    And I should be on the Users screen
    And I should see a table containing "Jack Dempsey" 
    And I should not see "Brian Knorr" 

Scenario: Updating user roles
    Given test user Brian is present
    When I touch "Brian Knorr"
    And I touch "User Roles"
    And I scroll down 4 rows
    Then the "Returns" table view cell should not have a checkmark accessory
    
    When I touch "Returns"
    Then the "Returns" table view cell should have a checkmark accessory

    When I touch "Returns"
    Then the "Returns" table view cell should not have a checkmark accessory
