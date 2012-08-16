@simulator_only
Feature: Launching your app in both iPhone or iPad idioms

Scenario: Launching in iPhone explicitly
  When I launch the app using the iphone simulator
  And I pause briefly for demonstration purposes

Scenario: Launching in iPad explicitly
  When I launch the app using the ipad simulator
  And I pause briefly for demonstration purposes

Scenario: Launching in iPhone by default
  When I launch the app
  And I pause briefly for demonstration purposes
