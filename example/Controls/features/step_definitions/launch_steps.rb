Given /^I launch the app$/ do
  unless $USING_PHYSICAL_DEVICE
    launch_app APP_BUNDLE_PATH unless ENV.key?('DONT_RELAUNCH')
  end
end

Given /^I launch the app using the (iphone|ipad) simulator$/ do |idiom|
  unless $USING_PHYSICAL_DEVICE
    sdk = nil # request default SDK, which will be the most recent
    launch_app APP_BUNDLE_PATH, nil, idiom
  end
end
