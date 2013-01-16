Feature:
	In order to write automated acceptance tests
	As a tester
	I want to be able to automate alert views

Background:
	Given I launch the app
	And I touch "UIAlertView"

Scenario: Showing the Alert View
	When I touch "Show UIAlertView"
	Then I should see "AlertView Title"

Scenario: Showing the Alert View in landscape mode
	Given the device is in landscape orientation
  And I wait for nothing to be animating
	When I touch "Show UIAlertView"
	Then I should see "AlertView Title"
