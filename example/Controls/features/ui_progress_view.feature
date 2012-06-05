Feature: 
				In order to write automated acceptance tests
				As a tester
				I want Frank to be able to wait for a progress view to complete it's progress

				Background:
								Given I launch the app
								And I touch "UIProgressView"

				Scenario: Reading the current value of the progress view
								Given I touch "Start" 
								Then I wait until the progress of "Progress" is 1
