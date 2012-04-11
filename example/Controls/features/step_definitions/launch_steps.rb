Given /^I launch the app$/ do
  app_path = ENV['APP_BUNDLE_PATH'] || (defined?(APP_BUNDLE_PATH) && APP_BUNDLE_PATH)
  launch_app app_path unless ENV.key?('DONT_RELAUNCH')
end
