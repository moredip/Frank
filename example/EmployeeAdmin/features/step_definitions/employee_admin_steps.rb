Given /^the app has just started$/ do
require 'sim_launcher/client'

  app_path = File.dirname(__FILE__) + "/../../build/Debug-iphonesimulator/EmployeeAdmin.app"
  simulator = SimLauncher::Client.for_iphone_app( app_path, "4.2" )

  num_timeouts = 0
  loop do
    begin
      simulator.relaunch
      wait_for_frank_to_come_up
      break # if we make it this far without an exception then we're good to move on

    rescue Timeout::Error
      num_timeouts += 1
      puts "Encountered #{num_timeouts} timeouts while launching the app."
      if num_timeouts > 3
        raise "Encountered #{num_timeouts} timeouts in a row while trying to launch the app." 
      end
    end
  end
end

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
