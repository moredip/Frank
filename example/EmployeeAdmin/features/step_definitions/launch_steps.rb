Given /^I launch the app$/ do
  launch_app APP_BUNDLE_PATH, ENV.fetch('FRANK_SDK_VERSION',nil)
end
