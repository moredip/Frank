Feature: 
In order to write automated acceptance tests
As a tester
I want Frank to be able to automate advanced UI features of a UITableView

Background:
Given I launch the app
And I touch "Editable Table"

Scenario: Checking for elements in a table
  Then I should see "Larry"
  And I should see "Curly"
  But I should not see "Some other name"

@not_supported_by_frank_yet
Scenario: Swipe to delete
 When I swipe "Larry" rightwards
 Then I should see "Delete"
 
 When I touch "Delete"
 Then I should not see "Delete"
 And I should not see "Larry"

