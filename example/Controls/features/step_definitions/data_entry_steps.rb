Given /^I am on a fresh Data Entry screen$/ do
  step "I ask the app to reset to home"
  touch "view marked:'Data Entry'"
  wait_for_nothing_to_be_animating
end

Then /^I should be able to enter "(.*?)" correctly using the keyboard$/ do |text_to_type|
  step %Q|I type "#{text_to_type}" into the "Edit me" text field using the keyboard|
  
  expected_text = "text entered into text field: #{text_to_type}"
  check_element_exists( "view:'UILabel' text:'#{expected_text}'" )
end

When /^I elect to use the Email keyboard$/ do
  touch "view:'UISegment' marked:'Email'"
end

When /^I turn on auto\-capitalization$/ do
  touch "view:'UISwitch' marked:'Capitalize'"
  sleep 0.5 #wait for switch animation to complete
end


