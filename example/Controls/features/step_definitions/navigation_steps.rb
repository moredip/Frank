Then /^I should be in the "([^"]*)" view$/ do |expected_view_title|
  expected_mark = "view:'UINavigationItemView' marked:'#{expected_view_title}'"
  wait_for_element_to_exist expected_mark
end

When /^I ask the app to reset to home$/ do
  app_exec 'popToRootViewController:', true
  wait_for_nothing_to_be_animating
end
