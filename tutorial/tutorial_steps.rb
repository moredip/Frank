Given /^the app is launched$/ do
  launch_app_in_simulator
  wait_for_frank_to_come_up
end

When /^I touch the Plus button$/ do
  touch( "navigationButton marked:'Add'" )
end

Then /^I should see a table containing a timestamp$/ do
  cell_label = frankly_map( "tableView tableViewCell first", "text" );
  puts "label: #{cell_label}"
end

