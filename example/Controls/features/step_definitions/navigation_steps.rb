Then /^I should be in the "([^"]*)" view$/ do |expected_view_title|
  expected_mark = "view:'UINavigationItemView' marked:'#{expected_view_title}'"

  Timeout::timeout(WAIT_TIMEOUT) do
    until view_with_mark_exists( expected_mark )
      sleep 0.1
    end
  end
end

When /^I ask the app to reset to home$/ do
  app_exec 'popToRootViewController:', true
end
