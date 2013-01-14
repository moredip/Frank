Feature: I can scroll a table with unusual properties (e.g. big header, no rows)

Background:
Given I launch the app
And I scroll the table to the bottom
And I touch "Empty Table"

Scenario: Scroll to the bottom of the table
    When I scroll the table to the bottom
    Then I should see "table footer"
