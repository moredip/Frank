WAIT_TIMEOUT = 240

require 'rspec/expectations'

# -- See -- #
Then /^I wait to see "([^\"]*)"$/ do |expected_mark|
  Timeout::timeout(WAIT_TIMEOUT) do
    until view_with_mark_exists( expected_mark )
      sleep 0.1
    end
  end
end

Then /^I wait to not see "([^\"]*)"$/ do |expected_mark|
  sleep 3
  Timeout::timeout(WAIT_TIMEOUT) do
    while element_exists( "view marked:'#{expected_mark}'" )
      sleep 0.1
    end
  end
end

Then /^I wait to see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
    Timeout::timeout(30) do
      values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
      until values.include?(expected_mark)
        values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
        sleep 0.1
      end
    end
end

Then /^I wait to not see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
    Timeout::timeout(30) do
      values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
      while values.include?(expected_mark)
        values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
        sleep 0.1
      end
    end
end

Then /^I should see a "([^\"]*)" button$/ do |expected_mark|
  check_element_exists("button marked:'#{expected_mark}'")
end

Then /^I should see "([^\"]*)"$/ do |expected_mark|
  check_element_exists("view marked:'#{expected_mark}'")
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

Then /^I should see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
  values.should include(expected_mark)
end

Then /^I should see an alert view titled "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'alertView', 'message')
  puts values
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
	element_is_not_hidden("view:'#{className}'")
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
  When %Q|I type "#{text_to_type}" into the "#{text_field}" text field|
end

When /^I fill in text fields as follows:$/ do |table|
  table.hashes.each do |row|
    When %Q|I type "#{row['text']}" into the "#{row['field']}" text field|
  end
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

When /^I flip switch "([^\"]*)" on$/ do |mark|
  selector = "view:'UISwitch' marked:'#{mark}'"
  views_switched = frankly_map( selector, 'setOn:animated:', true, true )
  raise "could not find anything matching [#{uiquery}] to switch" if views_switched.empty?
end

When /^I flip switch "([^\"]*)" off$/ do |mark|
  selector = "view:'UISwitch' marked:'#{mark}'"
  views_switched = frankly_map( selector, 'setOn:animated:', false, true )
  raise "could not find anything matching [#{uiquery}] to switch" if views_switched.empty?
end

When /^I flip switch "([^\"]*)"$/ do |mark|
  touch("view:'UISwitch' marked:'#{mark}'") 
end

Then /^switch "([^\"]*)" should be on$/ do |mark|
#  switch_states = frankly_map( "view:'Switch' marked:'#{mark}'", "isOn" )
  switch_states = frankly_map( "view accesibilityLabel:'#{mark}'", "isOn" )
  puts "test #{switch_states.inspect}"
  
  if switch_states == 0
    puts "Switch #{mark} is ON"
  else
    puts "Switch #{mark} is OFF, flim switch ON"
    Then %Q|I flip switch "#{mark}"|
  end
end

Then /^switch "([^\"]*)" should be off$/ do |mark|
  switch_states = frankly_map( "view:'UISwitch' marked:'#{mark}'", "isOn" )
  puts "test #{switch_states.inspect}"
  
  if switch_states == 0
    puts "Switch #{mark} is ON, flip switch OFF"
    Then %Q|I flip switch "#{mark}"|
  else
    puts "Switch #{mark} is OFF"
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
