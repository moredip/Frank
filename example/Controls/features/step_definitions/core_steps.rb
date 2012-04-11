When /^I swipe "([^"]*)" leftwards$/ do |mark|
  frankly_map( "view:'UISwitch' marked:'#{mark}'", 'swipeLeftwards' )
end
