When /^I set the device's location to Stockholm$/ do
  set_location(:latitude => 59.338886, :longitude => 18.058426)
end

Then /^I should see that my current location is reported as Stockholm$/ do
  wait_for_element_to_exist "view marked:'Current Location: 59.338886,18.058426'"
end

