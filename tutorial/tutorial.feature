Feature: Drive our SampleNavApp using Cucumber

Scenario: Plus button adds timestamp
  Given the app is launched
  When I touch the Plus button
  Then I should see a table containing a timestamp

