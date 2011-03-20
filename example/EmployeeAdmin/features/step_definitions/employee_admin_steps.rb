When /^I touch the Add User button$/ do
  touch( "navigationButton" )  
end

Then /^I should be on the Users screen$/ do
  Then %q|I should see "Users"|
end

Given /^test user Brian is present$/ do
  steps <<EOS 
    Given I should be on the Users screen
    When I touch the Add User button
    And I fill in text fields as follows:
      | field      | text   |
      | First Name | Brian  |
      | Last Name  | Knorr  |
      | Email      | a@b.c  |
      | Username   | bknorr |
      | Password   | 123    |
      | Confirm    | 123    |
    And I touch "Save"
    Then I should be on the Users screen
EOS
end
