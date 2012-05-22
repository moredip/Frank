When /^I confirm table cell deletion$/ do
  wait_for_nothing_to_be_animating
  touch "view:'UITableViewCellDeleteConfirmationControl'"
  wait_for_nothing_to_be_animating
end

When /^I touch the delete edit control for the table view cell "([^"]*)"$/ do |tvc_mark|
  delete_control_selector = "view:'UITableViewCell' view marked:'#{tvc_mark}' parent view:'UITableViewCell' view:'UITableViewCellEditControl'" 
  touch delete_control_selector
end
