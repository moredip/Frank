WAIT_TIMEOUT = ENV['WAIT_TIMEOUT'].to_i || 240

require 'rspec/expectations'

# -- See -- #
Then /^I wait to see "([^\"]*)"$/ do |expected_mark|
  wait_until(:message => "waited to see view marked '#{expected_mark}'"){ 
    view_with_mark_exists( expected_mark ) 
  }
end

Then /^I wait to not see "([^\"]*)"$/ do |expected_mark|
  sleep 3 # ugh, this should be removed but I'm worried it'll break existing tests

  wait_until(:message => "waited to not see view marked '#{expected_mark}'"){ 
    !view_with_mark_exists( expected_mark )
  }
end

Then /^I should see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  check_element_exists( "navigationItemView marked:'#{expected_mark}'" )
end

Then /^I wait to see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  wait_until( :timeout => 30, :message => "waited to see a navigation bar titled '#{expected_mark}'" ) {
    element_exists( "navigationItemView marked:'#{expected_mark}'" )
  }
end

Then /^I wait to not see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  wait_until( :timeout => 30, :message => "waited to not see a navigation bar titled '#{expected_mark}'" ) {
    !element_exists( "navigationItemView marked:'#{expected_mark}'" )
  }
end

Then /^I should see a "([^\"]*)" button$/ do |expected_mark|
  check_element_exists("button marked:'#{expected_mark}'")
end

Then /^I should see "([^\"]*)"$/ do |expected_mark|
  check_view_with_mark_exists(expected_mark)
end

Then /^I should not see "([^\"]*)"$/ do |expected_mark|
  check_element_does_not_exist("view marked:'#{expected_mark}'")
end

Then /I should see the following:/ do |table|
  values = frankly_map( 'view', 'accessibilityLabel' )
  table.raw.each do |expected_mark|
    values.should include( expected_mark.first )
  end
end

Then /I should not see the following:/ do |table|
  values = frankly_map( 'view', 'accessibilityLabel' )
  table.raw.each do |expected_mark|
    values.should_not include( expected_mark.first )
  end
end

Then /^I should see an alert view titled "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'alertView', 'message')
  values.should include(expected_mark)
end

Then /^I should not see an alert view$/ do
  check_element_does_not_exist( 'alertView' )
end

Then /^I should see an element of class "([^\"]*)" with name "([^\"]*)" with the following labels: "([^\"]*)"$/ do |className, classLabel, listOfLabels|
	arrayOfLabels = listOfLabels.split(',');
	arrayOfLabels.each do |label|
		check_element_exists("view marked:'#{classLabel}' parent view:'#{className}' descendant view marked:'#{label}'")
	end
end

Then /^I should see an element of class "([^\"]*)" with name "([^\"]*)" with a "([^\"]*)" button$/ do |className, classLabel, buttonName|
	check_element_exists("view marked:'#{classLabel}' parent view:'#{className}' descendant button marked:'#{buttonName}'")
end

Then /^I should not see a hidden button marked "([^\"]*)"$/ do |expected_mark|
  element_is_not_hidden("button marked:'#{expected_mark}'").should be_false
end

Then /^I should see a nonhidden button marked "([^\"]*)"$/ do |expected_mark|
  element_is_not_hidden("button marked:'#{expected_mark}'").should be_true
end

Then /^I should see an element of class "([^\"]*)"$/ do |className|
  element_is_not_hidden("view:'#{className}'").should be_true
end

Then /^I should not see an element of class "([^\"]*)"$/ do |className|
  selector = "view:'#{className}'"
  element_exists_and_is_not_hidden = element_exists( selector ) && element_is_not_hidden(selector)
  element_exists_and_is_not_hidden.should be_false
end


# -- Type/Fill in -- #

When /^I type "([^\"]*)" into the "([^\"]*)" text field$/ do |text_to_type, field_name|
  text_fields_modified = frankly_map( "textField placeholder:'#{field_name}'", "setText:", text_to_type )
  raise "could not find text fields with placeholder '#{field_name}'" if text_fields_modified.empty?
  #TODO raise warning if text_fields_modified.count > 1
end

# alias 
When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |text_field, text_to_type|
  step %Q|I type "#{text_to_type}" into the "#{text_field}" text field|
end

When /^I fill in text fields as follows:$/ do |table|
  table.hashes.each do |row|
    step %Q|I type "#{row['text']}" into the "#{row['field']}" text field|
  end
end

# simulate entering text from keyboard
When /^I enter the text "([^\\"]*)" from keyboard to the textfield "([^\\"]*)"$/ do |text_to_type, text_field_mark| # !> ambiguous first argument; put parentheses or even spaces
  selector = "view marked:'#{text_field_mark}' first"
  if element_exists(selector)
     touch( selector )
  else
     raise "Could not find [#{text_field_mark}], it does not exist."
  end
  text_field_selector =  "textField placeholder:'#{text_field_mark}'"
  frankly_map( text_field_selector, 'becomeFirstResponder' )
  frankly_map( text_field_selector, 'setText:', text_to_type )
  frankly_map( text_field_selector, 'endEditing:', true )
end

# -- Rotate -- #
Given /^the device is in (a )?landscape orientation$/ do |ignored|
  # for some reason the simulator sometimes starts of reporting its orientation as 'flat'. Workaround for this is to rotate the device then wait a bit
  if 'flat' == frankly_current_orientation
    rotate_simulator_right
    sleep 1
  end 
  
  unless frankly_oriented_landscape?
    rotate_simulator_left
    sleep 1
    raise "expected orientation to be landscape after rotating left, but it is #{frankly_current_orientation}" unless frankly_oriented_landscape?
  end
end

Given /^the device is in (a )?portrait orientation$/ do |ignored|
  # for some reason the simulator sometimes starts of reporting its orientation as 'flat'. Workaround for this is to rotate the device then wait a bit
  if 'flat' == frankly_current_orientation
    rotate_simulator_right
    sleep 1
  end 

  unless frankly_oriented_portrait?
    rotate_simulator_left
    sleep 1
    raise "Expected orientation to be portrait after rotating left, but it is #{frankly_current_orientation}" unless frankly_oriented_portrait?
  end
end

When /^I simulate a memory warning$/ do
  simulate_memory_warning
end

Then /^I rotate to the "([^\"]*)"$/ do |direction|
  if direction == "right"
    rotate_simulator_right
  elsif direction == "left"
    rotate_simulator_left
  else 
    raise %Q|Rotation direction specified ("#{direction}") is invalid. Please specify right or left.|
  end
  sleep 1
end

# -- touch -- #
When /^I touch "([^\"]*)"$/ do |mark|
  selector = "view marked:'#{mark}' first"
  if element_exists(selector)
     touch( selector )
  else
     raise "Could not touch [#{mark}], it does not exist."  
  end
  sleep 1
end

When /^I touch "([^\"]*)" if exists$/ do |mark|
  sleep 1
  selector = "view marked:'#{mark}' first"
  if element_exists(selector)
  	touch(selector)
    sleep 1
  end
end

When /^I touch the first table cell$/ do
    touch("tableViewCell first")
end

When /^I touch the table cell marked "([^\"]*)"$/ do |mark|
  touch("tableViewCell marked:'#{mark}'")
end

When /^I touch the (\d*)(?:st|nd|rd|th)? table cell$/ do |ordinal|
    ordinal = ordinal.to_i - 1
    touch("tableViewCell index:#{ordinal}")
end

Then /I touch the following:/ do |table|
  values = frankly_map( 'view', 'accessibilityLabel' )
  table.raw.each do |expected_mark|
    touch( "view marked:'#{expected_mark}'" )
    sleep 2
  end
end

When /^I touch the button marked "([^\"]*)"$/ do |mark|
  touch( "button marked:'#{mark}'" )
end

When /^I touch the "([^\"]*)" action sheet button$/ do |mark|
  touch( "actionSheet threePartButton marked:'#{mark}'" )
end

When /^I touch the (\d*)(?:st|nd|rd|th)? action sheet button$/ do |ordinal|
  ordinal = ordinal.to_i
  touch( "actionSheet threePartButton tag:#{ordinal}" )
end

When /^I touch the (\d*)(?:st|nd|rd|th)? alert view button$/ do |ordinal|
  ordinal = ordinal.to_i
  touch( "alertView threePartButton tag:#{ordinal}" )
end

# -- switch -- #

When /^I flip switch "([^\"]*)"$/ do |mark|
  touch("view:'UISwitch' marked:'#{mark}'") 
end


Then /^switch "([^\"]*)" should be (on|off)$/ do |mark,expected_state|
  expected_state = expected_state == 'on'

  selector = "view:'UISwitch' marked:'#{mark}'"
  switch_states = frankly_map( selector, "isOn" )

  switch_states.each do |switch_state|
    switch_state.should == expected_state
  end
end

# -- misc -- #

When /^I wait for ([\d\.]+) second(?:s)?$/ do |num_seconds|
  num_seconds = num_seconds.to_f
  sleep num_seconds
end

Then /^a pop\-over menu is displayed with the following:$/ do |table|
  sleep 1
  table.raw.each do |expected_mark|
    check_element_exists "actionSheet view marked:'#{expected_mark}'"
  end
end

Then /^I navigate back$/ do
  touch( "navigationItemButtonView" )
end

When /^I dump the DOM$/ do
  dom = frankly_dump
end

When /^I quit the simulator/ do
  quit_simulator 
end

When /^I reset the simulator/ do
  simulator_reset_data
end
