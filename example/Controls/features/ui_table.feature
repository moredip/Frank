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
 Then I should see the confirm deletion button
 
 When I confirm table cell deletion
 Then I should not see the confirm deletion button
 And I should not see "Larry"
 But I should see "Curly"
 And I should see "Moe"

Scenario: delete with edit mode
 When I touch "Edit"
 And I touch the delete edit control for the table view cell "Moe"
 Then I should see the confirm deletion button

 When I confirm table cell deletion
 Then I should not see the confirm deletion button
 
 And I should not see "Moe"
 But I should see "Larry"
 And I should see "Curly"

Scenario: delete with swipe ends edit mode
 When I swipe "Larry" leftwards
 Then I should see a "Done" button
 And I should not see an "Edit" button

 When I confirm table cell deletion
 Then I should see an "Edit" button
 Then I should not see a "Done" button

Scenario: deleting in edit mode does not end edit mode
 When I touch "Edit"
 Then I should see a "Done" button
 And I should not see an "Edit" button

 When I touch the delete edit control for the table view cell "Moe"
 And I confirm table cell deletion
 Then I should see a "Done" button
 And I should not see an "Edit" button

Scenario: scrolling up and down and all around
 When I scroll the table to the bottom
 Then I should see "Last Row"
 
 When I scroll the table to the 3rd row
 Then I should see "Curly"
 But I should not see "Larry"
 
 When I scroll the table to the top
 Then I should see "First Row"
