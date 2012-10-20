Then /^I should (?:\w+ )see (\d+) squares in total?$/ do |count|
  count = count.to_i
  frankly_map( "view marked:'square'", "tag").should have(count).items
end

Then /^I should see (\d+) hidden squares in total$/ do |count|
  sleep 1
  count = count.to_i
  frankly_map( "view marked:'square' isHidden", "tag").should have(count).items
end

Then /^I should see a hidden (\w+) square$/ do |color|
  wait_for_element_to_exist( "view marked:'#{color} square' isHidden" )
end

Then /^I should(?: \w+)? see an? (\w+) square$/ do |color|
  wait_for_element_to_exist( "view marked:'#{color} square'" )
end
