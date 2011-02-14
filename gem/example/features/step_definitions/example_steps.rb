Given /^I wait (\d+) seconds$/ do |seconds|
  seconds = seconds.to_i
  sleep seconds
end

Then /^the test fails$/ do
  (2+2).should == 5
end

Then /^the test passes!$/ do
  (2+2).should == 4
end


Then /^I see colors!$/ do
  announce red "RED"
  announce blue "BLUE"
  announce green "GREEEN!"
end
