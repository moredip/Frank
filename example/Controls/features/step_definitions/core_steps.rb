When /^I swipe "([^"]*)" (left|right|up|down)wards$/ do |mark,direction|
  frankly_map( "view:'UISwitch' marked:'#{mark}'", 'swipeInDirection:', direction )
end

Then /^I should see a label with the text "([^"]*)"$/ do |expected_text|
  check_element_exists( "view:'UILabel' text:'#{expected_text}'" )
end
