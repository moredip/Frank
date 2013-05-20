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

Scenario: Launching in Retina iPad explicitly
  When I launch the app using the retina ipad simulator
  And I pause briefly for demonstration purposes

Scenario: Launching in Retina iPhone (3.5 inch) explicitly
  When I launch the app using the retina iphone (3.5 inch) simulator
  And I pause briefly for demonstration purposes

Scenario: Launching in Retina iPhone (4 inch) explicitly
  When I launch the app using the retina iphone (4 inch) simulator
  And I pause briefly for demonstration purposes

Scenario: Launching a device in the iPhone family launches iPhone
  When I launch the app using the iphone family simulator
  And I pause briefly for demonstration purposes

Scenario: Launching a device in the iPad family launches iPad
  When I launch the app using the ipad family simulator
  And I pause briefly for demonstration purposes
