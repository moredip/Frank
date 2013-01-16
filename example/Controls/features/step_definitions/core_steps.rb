When /^I swipe "([^"]*)" (left|right|up|down)wards$/ do |mark,direction|
  frankly_map( "view marked:'#{mark}'", 'swipeInDirection:', direction )
end

When /^I wait for nothing to be animating$/ do
  wait_for_nothing_to_be_animating
end

Then /^I should see a label with the text "([^"]*)"$/ do |expected_text|
  check_element_exists( "view:'UILabel' text:'#{expected_text}'" )
end

Then /^I should wait to see "([^"]*)"$/ do |expected_mark|
  wait_for_element_to_exist("view marked:'#{expected_mark}'")
end

Then /^I should see "(.*?)" even though it is hidden$/ do |expected_mark| 
  check_element_exists("view marked:'#{expected_mark}'")
end

Then /^there should be a hidden view "(.*?)"$/ do |expected_mark|
  wait_for_element_to_exist("view marked:'#{expected_mark}' isHidden")
end

Then /^there should not be any hidden views$/ do
  frankly_map("view isHidden",'tag').should be_empty
end

Then /^I wait until the progress of "([^"]*)" is (\d+)$/ do |mark, required_value|
  required_value = required_value.to_f
  wait_until do 
    progresses = frankly_map( "view:'UIProgressView' marked:'#{mark}'", 'progress' )
    raise "no progress views found with mark '#{mark}'" if progresses.empty?
    raise "more than one progress views found with mark '#{mark}'" if progresses.count > 1
    required_value == progresses.first
  end
end



When /^I type "([^"]*)" into the "([^"]*)" text field using the keyboard$/ do |text_to_type, placeholder|
  touch( "textField placeholder:'#{placeholder}'" )
  sleep(0.2) # wait for keyboard to animate in
  wait_for_nothing_to_be_animating
  type_into_keyboard( text_to_type )
end

When /^I delete (\d+) characters from the "(.*?)" text field using the keyboard$/ do |num_deletes, placeholder|
  num_deletes = num_deletes.to_i
  text_to_type = "\b"*num_deletes

  touch( "textField placeholder:'#{placeholder}'" )
  sleep(0.2) # wait for keyboard to animate in
  wait_for_nothing_to_be_animating
  type_into_keyboard( text_to_type )
end

When /^I pause briefly for demonstration purposes$/ do
  sleep 1.5
end
