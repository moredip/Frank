Feature: 
				In order to write automated acceptance tests
				As a tester
				I want Frank to be able to automate UISwitches

				Background:
								Given I launch the app
								And I touch "UISwitch"

				Scenario: Flipping the switch off and on
								Given switch "the switch" should be on

								When I touch "the switch"
								Then switch "the switch" should be off
								Then I should see "Switch is off"

								When I touch "the switch"
								Then switch "the switch" should be on
								Then I should see "Switch is on"

				# STILL TO DO
				#Scenario: setting the switch declaratively
				#Scenario: swiping the switch on
				#Scenario: swiping the switch off
