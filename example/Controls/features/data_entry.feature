Feature: 
  In order to write automated acceptance tests
  As a tester
  I want Frank to be able to automate controls which use the iOS keyboard for data entry

Background:
	Given I am on a fresh Data Entry screen

Scenario: Entering text into a text field in landscape
	Given the device is in landscape orientation
	And I wait for nothing to be animating
	Then I should be able to enter "some text" correctly using the keyboard

Scenario: Entering text into a text field in portrait
  Given the device is in portrait orientation
  And I wait for nothing to be animating
  Then I should be able to enter "some text" correctly using the keyboard

Scenario: Deleting text in a text field
  When I type "1234567" into the "Edit me" text field using the keyboard
	And I delete 3 characters from the "Edit me" text field using the keyboard
	Then I should see a label with the text "text entered into text field: 1234"

Scenario: Using the Email keyboard
  When I elect to use the Email keyboard
  Then I should be able to enter "foo@example.com" correctly using the keyboard

Scenario: Enter text into an auto-capitalizing field
  Given this scenario is MARKED PENDING because there seems to be a bug in KIFTypist for auto-capitalized fields
  When I turn on auto-capitalization
  Then I should be able to enter "foo bar baz" correctly using the keyboard
