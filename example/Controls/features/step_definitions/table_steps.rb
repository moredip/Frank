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
