WAIT_TIMEOUT = ENV['WAIT_TIMEOUT'].to_i || 240

require 'rspec/expectations'

# -- See -- #
Then /^I wait to see "([^\"]*)"$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  wait_until(:message => "waited to see view marked #{quote}#{expected_mark}#{quote}"){
    view_with_mark_exists( expected_mark )
  }
end

Then /^I wait to not see "([^\"]*)"$/ do |expected_mark|
  sleep 3 # ugh, this should be removed but I'm worried it'll break existing tests
  quote = get_selector_quote(expected_mark)
  wait_until(:message => "waited to not see view marked #{quote}#{expected_mark}#{quote}"){
    !view_with_mark_exists( expected_mark )
  }
end

Then /^I should see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  check_element_exists( "navigationItemView marked:#{quote}#{expected_mark}#{quote}" )
end

Then /^I wait to see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  wait_until( :timeout => 30, :message => "waited to see a navigation bar titled #{quote}#{expected_mark}#{quote}" ) {
    element_exists( "navigationItemView marked:#{quote}#{expected_mark}#{quote}" )
  }
end

Then /^I wait to not see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  wait_until( :timeout => 30, :message => "waited to not see a navigation bar titled #{quote}#{expected_mark}#{quote}" ) {
    !element_exists( "navigationItemView marked:#{quote}#{expected_mark}#{quote}" )
  }
end

Then /^I should see a "([^\"]*)" button$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  check_element_exists("button marked:#{quote}#{expected_mark}#{quote}")
end

Then /^I should see "([^\"]*)"$/ do |expected_mark|
  check_view_with_mark_exists(expected_mark)
end

Then /^I should not see "([^\"]*)"$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  check_element_does_not_exist_or_is_not_visible("view marked:#{quote}#{expected_mark}#{quote}")
end

Then /I should see the following:/ do |table|
  values = frankly_map( 'view', 'FEX_accessibilityLabel' )
  table.raw.each do |expected_mark|
    values.should include( expected_mark.first )
  end
end

Then /I should not see the following:/ do |table|
  values = frankly_map( 'view', 'FEX_accessibilityLabel' )
  table.raw.each do |expected_mark|
    values.should_not include( expected_mark.first )
  end
end

Then /^I should see an alert view titled "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'alertView', 'title')
  values.should include(expected_mark)
end

Then /^I should see an alert view with the message "([^\"]*)"$/ do |expected_mark|
    values = frankly_map( 'alertView', 'message')
    values.should include(expected_mark)
end

Then /^I should not see an alert view$/ do
  check_element_does_not_exist( 'alertView' )
end

Then /^I should see an element of class "([^\"]*)" with name "([^\"]*)" with the following labels: "([^\"]*)"$/ do |className, classLabel, listOfLabels|
	arrayOfLabels = listOfLabels.split(',');
	arrayOfLabels.each do |label|
    quote = get_selector_quote(label)
		check_element_exists("view marked:'#{classLabel}' parent view:'#{className}' descendant view marked:#{quote}#{label}#{quote}")
	end
end

Then /^I should see an element of class "([^\"]*)" with name "([^\"]*)" with a "([^\"]*)" button$/ do |className, classLabel, buttonName|
  quote = get_selector_quote(buttonName)
	check_element_exists("view marked:'#{classLabel}' parent view:'#{className}' descendant button marked:#{quote}#{buttonName}#{quote}")
end

Then /^I should not see a hidden button marked "([^\"]*)"$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  element_is_not_hidden("button marked:#{quote}#{expected_mark}#{quote}").should be_false
end

Then /^I should see a nonhidden button marked "([^\"]*)"$/ do |expected_mark|
  quote = get_selector_quote(expected_mark)
  element_is_not_hidden("button marked:#{quote}#{expected_mark}#{quote}").should be_true
end

Then /^I should see an element of class "([^\"]*)"$/ do |className|
  element_is_not_hidden("view:'#{className}'").should be_true
end

Then /^I should not see an element of class "([^\"]*)"$/ do |className|
  selector = "view:'#{className}'"
  element_exists_and_is_not_hidden = element_exists( selector ) && element_is_not_hidden(selector)
  element_exists_and_is_not_hidden.should be_false
end


# -- Rotate -- #
Given /^the device is in (a )?(landscape|portrait) orientation$/ do |_,orientation|
  frankly_set_orientation orientation
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
# generic views
When /^I touch "([^\"]*)"$/ do |mark|
  quote = get_selector_quote(mark)
  selector = "view marked:#{quote}#{mark}#{quote} first"
  if element_exists(selector)
     touch( selector )
  else
     raise "Could not touch [#{mark}], it does not exist."
  end
  sleep 1
end

When /^I touch "([^\"]*)" if exists$/ do |mark|
  sleep 1
  quote = get_selector_quote(mark)
  selector = "view marked:#{quote}#{mark}#{quote} first"
  if element_exists(selector)
  	touch(selector)
  end
end

# table cells
When /^I touch the first table cell$/ do
    touch("tableViewCell first")
end

When /^I touch the table cell marked "([^\"]*)"$/ do |mark|
  quote = get_selector_quote(mark)
  touch("tableViewCell marked:#{quote}#{mark}#{quote}")
end

When /^I touch the (\d*)(?:st|nd|rd|th)? table cell$/ do |ordinal|
    ordinal = ordinal.to_i - 1
    touch("tableViewCell index:#{ordinal}")
end

Then /I touch the following:/ do |table|
  values = frankly_map( 'view', 'FEX_accessibilityLabel' )
  table.raw.each do |expected_mark|
    quote = get_selector_quote(expected_mark)
    touch( "view marked:#{quote}#{expected_mark}#{quote}" )
    sleep 2
  end
end

# buttons
When /^I touch the button marked "([^\"]*)"$/ do |mark|
  quote = get_selector_quote(mark)
  touch( "button marked:#{quote}#{mark}#{quote}" )
end

# action sheets
When /^I touch the "([^\"]*)" action sheet button$/ do |mark|
  quote = get_selector_quote(mark)
  touch( "actionSheet threePartButton marked:#{quote}#{mark}#{quote}" )
end

When /^I touch the (\d*)(?:st|nd|rd|th)? action sheet button$/ do |ordinal|
  ordinal = ordinal.to_i
  touch( "actionSheet threePartButton tag:#{ordinal}" )
end

# alert views
When /^I touch the "([^\"]*)" alert view button$/ do |mark|
  quote = get_selector_quote(mark)
  touch( "alertView threePartButton marked:#{quote}#{mark}#{quote}" )
end

When /^I touch the (\d*)(?:st|nd|rd|th)? alert view button$/ do |ordinal|
  ordinal = ordinal.to_i
  touch( "alertView threePartButton tag:#{ordinal}" )
end

# -- switch -- #

When /^I flip switch "([^\"]*)"$/ do |mark|
  quote = get_selector_quote(mark)
  touch("view:'UISwitch' marked:#{quote}#{mark}#{quote}")
end


Then /^switch "([^\"]*)" should be (on|off)$/ do |mark,expected_state|
  expected_state = expected_state == 'on'

  quote = get_selector_quote(mark)
  selector = "view:'UISwitch' marked:#{quote}#{mark}#{quote}"
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
    quote = get_selector_quote(expected_mark)
    check_element_exists "actionSheet view marked:#{quote}#{expected_mark}#{quote}"
  end
end

Then /^I navigate back$/ do
  touch( "navigationItemButtonView" )
  wait_for_nothing_to_be_animating
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
