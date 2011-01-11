WAIT_TIMEOUT = 240

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
      until values.include(expected_mark)
        values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
        sleep 0.1
      end
    end
end

Then /^I wait to not see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
    Timeout::timeout(30) do
      values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
      while values.include(expected_mark)
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

Then /^I should see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
  values.should include(expected_mark)
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
Given /^the device is in a landscape orientation$/ do
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

Given /^the device is in a portrait orientation$/ do
  # for some reason the simulator sometimes starts of reporting its orientation as 'flat'. Workaround for this is to rotate the device then wait a bit
  if 'flat' == frankly_current_orientation
    rotate_simulator_right
    sleep 1
  end
  
  unless frankly_oriented_portrait?
    rotate_simulator_left
    sleep 1
    raise "expected orientation to be portrait after rotating left, but it is #{frankly_current_orientation}" unless frankly_oriented_portrait?
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
	puts "[" + red('ERROR') + "] Direction specified is INVALID!!"
  end
  sleep 1
end

# -- touch -- #
When /^I touch "([^\"]*)"$/ do |mark|
  if element_exists("view marked:'#{mark}'")
     touch( "view marked:'#{mark}'" )
  else
     raise "[" + red('FAIL') + "] Can't touch. Element #{mark} does NOT exist!!"  
  end
  sleep 1
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

# -- switch -- #

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
