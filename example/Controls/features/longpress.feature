Feature:
	In order to write automated acceptance tests
	As a user
	I want to be able to perform long touches

	Background: 
		Given I launch the app
		And I touch "Long Press"

	Scenario: Long touch the main view
		When I press and hold "Long Touch View"
		Then I should see "YES" 

	Scenario: Long touch the main view at a specific point
		When I long press "Long Touch View" at x "60" y "40"
		Then I should see "YES"
		And I should see "{60, 40}"