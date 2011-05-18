Feature: Demonstrating using Frank to test the CountItOut example app

Background:
  Given the app is launched

Scenario: Zeroing out counts
  Given I touch "Zero Counts"	
	And I touch "Bites"
	And I wait 1 seconds
	And I touch "Bites"
	And I touch "Bites"
	And I wait 2 seconds
	And I touch "Bites"

