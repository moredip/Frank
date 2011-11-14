Feature: Various scenarios that exercise different parts of Frank

Background:
  Given I launch the app 

Scenario: Counting number of rows in a table section
  Then I should see 3 rows in section 0

Scenario: Scrolling to the bottom of the table 
    When I touch "Larry Stooge"
    And I touch "User Roles"
		Then I should not see "Returns"
		When I scroll to the bottom of the table
		Then I should see "Returns"
