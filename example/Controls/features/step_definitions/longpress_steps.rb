When /^I press and hold "(.*?)"$/ do |label|
	selector = %Q|view marked:'#{label}|
	tap_and_hold(selector)
end

When /^I long press "(.*?)" at x "(.*?)" y "(.*?)"$/ do |label, xcoord, ycoord|
	selector = %Q|view marked:'#{label}|
	tap_and_hold_point(selector, xcoord, ycoord)
end