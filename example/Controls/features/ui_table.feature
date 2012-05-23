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

Scenario: delete with swipe
 When I swipe "Larry" leftwards
 Then I should see "Delete"
 
 When I confirm table cell deletion
 Then I should not see "Delete"
 And I should not see "Larry"
 But I should see "Curly"
 And I should see "Moe"

Scenario: delete with edit mode
 When I touch "Edit"
 And I touch the delete edit control for the table view cell "Moe"
 Then I should see "Delete"

 When I confirm table cell deletion
 Then I should not see "Delete"

 And I should not see "Moe"
 But I should see "Larry"
 And I should see "Curly"
