Feature: Various scenarios that exercise different parts of Frank

Background:
  Given I launch the app 
  And I'm using Shelley

Scenario: Counting number of rows in a table section
  Then I should see 3 rows in section 0

