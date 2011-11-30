Given /^I launch the app using iOS (\d.\d)$/ do |version|
  # You can grab a list of the installed SDK with sim_launcher
  # > run sim_launcher from the command line
  # > open a browser to http://localhost:8881/showsdks
  # > use one of the version you see in parenthesis (e.g. 4.2)
  launch_app app_path, version
end

Given /^I launch the app$/ do
  launch_app app_path
end

def app_path
  ENV['APP_BUNDLE_PATH'] || (defined?(APP_BUNDLE_PATH) && APP_BUNDLE_PATH)
end
