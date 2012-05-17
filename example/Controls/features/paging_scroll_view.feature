Feature: 
  In order to write automated acceptance tests
  As a tester
  I want Frank to be able to automate UISwitches

  Background:
          Given I launch the app
          And I touch "Carousel"

  Scenario: Page to second image
    Given I see the 1st image in the carousel
    When I page the carousel to the right
    Then I see the 2nd image in the carousel

	Scenario: Trying to tap something that's not in view
    Given I see the 1st image in the carousel
		Then I shouldn't be able to touch the 3rd image in the carousel
