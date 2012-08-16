Feature: 
  In order to write automated acceptance tests
  As a tester
  I want Frank to be able to automate controls which use the iOS keyboard for data entry

Background:
  Given I launch the app
  And I touch "Data Entry"

Scenario: Entering text into a text field
  When I type "Some Text! $12^" into the "Edit me" text field using the keyboard
	Then I should see a label with the text "text entered into text field: Some Text! $12^"

Scenario: Deleting text in a text field
  When I type "1234567" into the "Edit me" text field using the keyboard
	And I delete 3 characters from the "Edit me" text field using the keyboard
	Then I should see a label with the text "text entered into text field: 1234"

