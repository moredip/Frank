@doubletap
Feature:
	In order to write automated acceptance tests
	As a user
	I want to be able to perform double taps

	Background: 
		Given I launch the app
		And I touch "Double Tap"

	Scenario: Long touch the main view
		When I double tap "Double Tap View"
		Then I should see "YES" 

	Scenario: Long touch the main view at a specific point
		When I douple tap "Double Tap View" at x "60" y "40"
		Then I should see "YES"
		And I should see "{60, 40}"