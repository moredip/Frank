When /^I type "([^\"]*)" into the "([^\"]*)" text field$/ do |text_to_type, mark|
  # TODO: extend frankly_map to support sending method arguments
  text_fields_modified = frankly_map( "textField placeholder:'#{mark}'", "setText:", text_to_type )
  raise "could not find text fields marked '#{text_to_type}'" if text_fields_modified.empty?
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

And /^I rotate to the "([^\"]*)"$/ do |direction|
  if direction == "right"
    rotate_simulator_right
  else
    rotate_simulator_left
  end
  sleep 1
end

Then /^I wait to see "([^\"]*)"$/ do |expected_mark|
  Timeout::timeout(30) do
    until view_with_mark_exists( expected_mark )
      sleep 0.1
    end
  end
end

Then /^I wait to not see "([^\"]*)"$/ do |expected_mark|
  Timeout::timeout(30) do
    while element_exists( "view marked:'#{expected_mark}'" )
      sleep 0.1
    end
  end
end

Then /^I should see "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'view', 'accessibilityLabel' )
  values.should include(expected_mark)
end

Then /^I should not see "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'view', 'accessibilityLabel' )
  values.should_not include(expected_mark)
end

Then /^I should see the following:$/ do |table|
  values = frankly_map( 'view', 'accessibilityLabel' )
  table.raw.each do |expected_mark|
    values.should include( expected_mark.first )
  end
end


Then /^I should see a navigation bar titled "([^\"]*)"$/ do |expected_mark|
  values = frankly_map( 'navigationItemView', 'accessibilityLabel' )
  values.should include(expected_mark)
end

When /^I touch "([^\"]*)"$/ do |mark|
  touch( "view marked:'#{mark}'" )
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


When /^I flip switch "([^\"]*)"$/ do |mark|
  touch("view:'UISwitch' marked:'#{mark}'") 
end

Then /^switch "([^\"]*)" should be (off|on)$/ do |mark,expected_state|
  switch_states = frankly_map( "view:'UISwitch' marked:'#{mark}'", "isOn" )
  puts switch_states
  pending # express the regexp above with the code you wish you had
end


Then /^I navigate back$/ do
  touch( "navigationItemButtonView" )
end

When /^I dump the DOM$/ do
  dom = frankly_dump
end
