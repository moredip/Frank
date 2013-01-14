When /^I double tap "(.*?)"$/ do |label|
	selector = %Q|view marked:'#{label}|
	double_tap(selector)
end

When /^I douple tap "(.*?)" at x "(.*?)" y "(.*?)"$/ do |label, xcoord, ycoord|
	selector = %Q|view marked:'#{label}|
	double_tap_point(selector, xcoord, ycoord)
end