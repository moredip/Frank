def check_nav_bar_for( expected_view_title )
  expected_mark = "view:'UINavigationItemView' marked:'#{expected_view_title}'"
  wait_for_element_to_exist expected_mark
end

Given /^I am have navigated to the "(.*?)" section$/ do |section_name|
  step 'I ask the app to reset to home'

  scroll_table_view_to_reveal_cell_with_contents( "tableView first", section_name )
  touch( "tableView first tableViewCell view marked:'#{section_name}'" )

  check_nav_bar_for(section_name)
end

Then /^I should be in the "([^"]*)" view$/ do |expected_view_title|
  check_nav_bar_for(expected_view_title)
end

When /^I ask the app to reset to home$/ do
  app_exec 'popToRootViewController:', true
  wait_for_nothing_to_be_animating
end
