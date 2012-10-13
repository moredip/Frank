Feature: 
  In order to write automated acceptance tests
  As a tester
  I want Frank to be able to automate controls which use the iOS keyboard for data entry

Background:
  Given I launch the app
  And I touch "Data Entry"

Scenario: Entering text into a text field
  When I type "some text" into the "Edit me" text field using the keyboard
	Then I should see a label with the text "text entered into text field: some text"

Scenario: Deleting text in a text field
  When I type "1234567" into the "Edit me" text field using the keyboard
	And I delete 3 characters from the "Edit me" text field using the keyboard
	Then I should see a label with the text "text entered into text field: 1234"

Scenario: Using the Email keyboard
  When I elect to use the Email keyboard
  When I type "foo@example.com" into the "Edit me" text field using the keyboard
	Then I should see a label with the text "text entered into text field: foo@example.com"
