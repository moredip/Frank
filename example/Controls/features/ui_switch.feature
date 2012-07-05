Feature: 
				In order to write automated acceptance tests
				As a tester
				I want Frank to be able to automate UISwitches

				Background:
								Given I launch the app
								And I touch "UISwitch"

				Scenario: Swiping the switch off and on
								Given switch "the switch" should be on

								When I touch "the switch"
								Then I should see "Switch is off"

								When I touch "the switch"
								Then I should see "Switch is on"
