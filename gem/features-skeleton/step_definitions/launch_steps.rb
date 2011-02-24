Given /^I launch the app$/ do
  launch_app_in_simulator
  wait_for_frank_to_come_up
end
