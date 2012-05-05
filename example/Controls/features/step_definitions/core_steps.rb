When /^I swipe "([^"]*)" (left|right|up|down)wards$/ do |mark,direction|
  frankly_map( "view:'UISwitch' marked:'#{mark}'", 'swipeInDirection:', direction )
end
