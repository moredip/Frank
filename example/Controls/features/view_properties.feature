Feature: 
  In order to write automated acceptance tests
  As a tester
  I want Frank to be able to inspect and modify general view properties

Background:
  Given I launch the app
  And I touch "View Properties"

Scenario: Selecting only non-hidden views
  When I touch "Hide blue"
	Then I should see a hidden blue square
	But I should still see a blue square

	And I should see an orange square

	And I should see 1 hidden squares in total
  But I should still see 2 squares in total
 