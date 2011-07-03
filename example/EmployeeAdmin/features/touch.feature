Feature: Demonstrating the touchx:y: api

Background:
    Given I launch the app 

Scenario: Add test user
  # about where "Larry Stooge" row should be in main screen
  When I touch the screen at (80,90) 
  Then I wait to see a navigation bar titled "User Profile"
  And I should see "Larry"
  And I should see "Stooge"
  And I should see "larry@stooges.com"
