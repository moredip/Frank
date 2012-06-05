When /^I swipe "([^"]*)" (left|right|up|down)wards$/ do |mark,direction|
  frankly_map( "view marked:'#{mark}'", 'swipeInDirection:', direction )
end

Then /^I should see a label with the text "([^"]*)"$/ do |expected_text|
  check_element_exists( "view:'UILabel' text:'#{expected_text}'" )
end

Then /^I should wait to see "([^"]*)"$/ do |expected_mark|
  wait_for_element_to_exist("view marked:'#{expected_mark}'")
end

Then /^I wait until the progress of "([^"]*)" is (\d+)$/ do |mark, required_value|
  progresses = frankly_map( "view:'UIProgressView' marked:'#{mark}'", 'progress' )
  puts progresses
end



When /^I type "([^"]*)" into the "([^"]*)" text field using the keyboard$/ do |text_to_type, placeholder|
  touch( "textField placeholder:'#{placeholder}'" )
  sleep(0.2) # wait for keyboard to animate in
  wait_for_nothing_to_be_animating
  type_into_keyboard( text_to_type )
end
