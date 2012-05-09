Feature: Demonstrating gesture support

Background:
  Given I launch the app 

Scenario: Starting to delete a user by swiping
  When I swipe "Larry Stooge" rightwards
  Then I should see "Delete"

Scenario: Touching absolute position on the screen
  When I tap "Larry Stooge"
  When I wait to see a navigation bar titled "User Profile"
  And I tap "User Roles"
  And I wait to see a navigation bar titled "User Roles"
  And I tap "User Profile"
  And I wait to see a navigation bar titled "User Profile"
  And I tap "Users"
  And I wait to see a navigation bar titled "Users"
