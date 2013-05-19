Given /^I launch the app$/ do
  unless $USING_PHYSICAL_DEVICE
    launch_app APP_BUNDLE_PATH unless ENV.key?('DONT_RELAUNCH')
  end
end

# for backwards compatibility. prefer specifying the device instead of the idiom
Given /^I launch the app using the (iphone|ipad) family simulator$/ do |idiom|
  unless $USING_PHYSICAL_DEVICE
    sdk = nil # request default SDK, which will be the most recent
    launch_app APP_BUNDLE_PATH, nil, idiom
  end
end

Given /^I launch the app using the (iphone|ipad|retina iphone \(3.5 inch\)|retina iphone \(4 inch\)|retina ipad) simulator$/ do |device|
  unless $USING_PHYSICAL_DEVICE
    launch_app_with_options APP_BUNDLE_PATH, :device => device
  end
end
