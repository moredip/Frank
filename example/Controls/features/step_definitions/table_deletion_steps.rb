When /^I confirm table cell deletion$/ do
  wait_for_nothing_to_be_animating
  touch "view:'UITableViewCellDeleteConfirmationControl'"
  wait_for_nothing_to_be_animating
end

When /^I touch the delete edit control for the table view cell "([^"]*)"$/ do |tvc_mark|
  delete_control_selector = "view:'UITableViewCell' view marked:'#{tvc_mark}' parent view:'UITableViewCell' view:'UITableViewCellEditControl'" 
  touch delete_control_selector
end

When /^I should see the confirm deletion button$/ do
    check_element_exists("view:'UITableViewCellDeleteConfirmationControl'")
end

When /^I should not see the confirm deletion button$/ do
    check_element_does_not_exist("view:'UITableViewCellDeleteConfirmationControl'")
end

Then /^I should not see an "(.*?)" button$/ do |button_mark|
    check_element_does_not_exist("button marked:'#{button_mark}'")
end

Then /^I should see an "(.*?)" button$/ do |button_mark|
    check_element_exists("button marked:'#{button_mark}'")
end

Then /^I should not see a "(.*?)" button$/ do |button_mark|
    check_element_does_not_exist("button marked:'#{button_mark}'")
end
