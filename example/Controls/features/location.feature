Feature: 
  In order to test how my app handles different locations
  As a tester
  I want Frank to be able to change the app's simulated location

  Background:
    Given I launch the app
    And I touch "Location"

  Scenario: 
    When I set the device's location to Stockholm
    Then I should see that my current location is reported as Stockholm
