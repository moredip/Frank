When /^I wait ([\d.]+) second(?:s)?$/ do |seconds|
  seconds = seconds.to_f
  sleep( seconds )
end

Then /^I should see a table containing "([^\"]*)"$/ do |expected_mark|
  check_element_exists( "tableView view marked:'#{expected_mark}'" )
end

Then /^I should see a table containing the following:$/ do |table|
  table.raw.each do |row|
    expected_mark = row.first
    check_element_exists( "tableView view marked:'#{expected_mark}'" )
  end
end

Then /^I should see (\d+) rows in section (\d+)$/ do |expected_num_rows, section|
  section = section.to_i
  expected_num_rows = expected_num_rows.to_i
  num_rows_array = frankly_map( "tableView first", "numberOfRowsInSection:", section ) 
  raise "no table found" if num_rows_array.empty?
  num_rows_array.first.should eq(expected_num_rows)
end

When /^I touch the "([^\"]*)" nav bar button$/ do |mark|
  touch( "navigationButton marked:'#{mark}'" )
end

When /^I tap "([^\"]*)"$/ do |mark|
  frankly_map( "view marked:'#{mark}' first", "tap" )
end

When /^I tap the screen at \((\d+),(\d+)\)$/ do |x, y|
  frankly_map( "view first", "tapAtPoint:", serialize_point(x,y) )
end

When /^I swipe "([^\"]*)" (.*)wards$/ do |mark,dir|
  frankly_map( "label marked:'#{mark}'", "swipeInDirection:", dir )
end


Then /^I should see an alert view saying "([^\"]*)"$/ do |expected_mark|
  check_element_exists( "alertView view marked:'#{expected_mark}'" )
end

When /^I scroll down (\d*)(?:st|nd|rd|th)? row(?:s)?$/ do |rows_to_scroll|
  rows_to_scroll = rows_to_scroll.to_i 
  tables_scrolled = frankly_map( "tableView", "scrollDownRows:", rows_to_scroll )
  raise "no table could be found to scroll" if tables_scrolled.empty?
  sleep 0.5 # give the UI a chance to animate the scrolling
end


When /^I scroll to the bottom of the table$/ do
  tables_scrolled = frankly_map( "tableView", "scrollToBottom" )
  raise "no table could be found to scroll" if tables_scrolled.empty?
  sleep 0.5 # give the UI a chance to animate the scrolling
end


Then /^the "([^\"]*)" table view cell should (not )?be selected$/ do |mark, qualifier|
  expected_to_be_selected = "not " != qualifier

  cell_query = "tableViewCell view marked:'#{mark}' parent tableViewCell"
  selection = frankly_map( cell_query, 'isSelected' ) 
  raise "no table view cells marked '#{mark}' exist" if selection.empty?
  raise "#{selection.count} table view cells marked '#{mark}' exist, don't know which one you want to verify" if selection.count > 1

  if expected_to_be_selected
    selection.first.should be_true
  else
    selection.first.should be_false
  end
end

# TODO: get the rest of these
ACCESSORY_STRING_TO_INT_MAP = {
  'checkmark' => 3
}

Then /^the "([^\"]*)" table view cell should (not )?have a (\w*) accessory$/ do |mark,qualifier,expected_accessory|
  accessory_type_should_match = "not " != qualifier
  expected_accessory_type = ACCESSORY_STRING_TO_INT_MAP[expected_accessory] 
  raise "unknown accessory type #{expected_accessory}" unless expected_accessory_type

  cell_query = "tableViewCell view marked:'#{mark}' parent tableViewCell"
  selection = frankly_map( cell_query, 'accessoryType' ) 
  raise "no table view cells marked '#{mark}' exist" if selection.empty?
  raise "#{selection.count} table view cells marked '#{mark}' exist, don't know which one you want to verify" if selection.count > 1

  if accessory_type_should_match
    selection.first.should == expected_accessory_type
  else
    selection.first.should_not == expected_accessory_type
  end

end


Then /^I should (not )?see a keyboard$/ do |negator|
  keyboards = frankly_map( "view:'UIKeyboardImpl'", 'tag' )
  if negator == "not "
    keyboards.should be_empty
  else
    keyboards.should_not be_empty
  end
end
