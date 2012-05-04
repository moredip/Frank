Feature: 
  In order to write automated acceptance tests
  As a tester
  I want Frank to be able to call methods on my app delegate


Scenario:
  Given I launch the app
	Then I should be in the "Root" view

  When I touch "UISwitch"
	Then I should be in the "UISwitch" view

	When I ask the app to reset to home
	Then I should be in the "Root" view
