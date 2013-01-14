When /^I scroll the table to the bottom$/ do
  scroll_view_to_bottom('tableView')
end

When /^I scroll the table to the (\d+)(?:st|nd|rd|th) row$/ do |row_ordinal|
  row_index = row_ordinal.to_i - 1
  scroll_table_view('tableView',row_index)
end

When /^I scroll the table to the top$/ do
  scroll_view_to_top('tableView')
end

When /^I put the table in edit mode$/ do
  touch %Q|view:'UINavigationButton' marked:'Edit'|
  wait_for_nothing_to_be_animating
end

When /^I drag the "(.*?)" row down to the "(.*?)" row$/ do |drag_row_mark, dest_row_mark|
  drag_target_selector = %Q|tableViewCell label marked:'#{drag_row_mark}' parent tableViewCell view:'UITableViewCellReorderControl'|
  drag_dest_selector = %Q|tableViewCell label marked:'#{dest_row_mark}' parent tableViewCell view:'UITableViewCellReorderControl'|

  drag_with_initial_delay( {:from => drag_target_selector,  :to => drag_dest_selector} )
end

Then /^the "(.*?)" row should be above the "(.*?)" row$/ do |high_row_mark, low_row_mark|
  high_row_frame = accessibility_frame( %Q|tableViewCell label marked:'#{high_row_mark}' parent tableViewCell| )
  low_row_frame = accessibility_frame( %Q|tableViewCell label marked:'#{low_row_mark}' parent tableViewCell| )
  high_row_frame.y.should < low_row_frame.y
end

