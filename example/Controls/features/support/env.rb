require 'frank-cucumber'

APP_BUNDLE_PATH= ENV['APP_BUNDLE_PATH'] || "Frank/frankified_build/Frankified.app"

Frank::Cucumber::FrankHelper.use_shelley_from_now_on

$USING_PHYSICAL_DEVICE = !!ENV['USE_PHYSICAL_DEVICE']

if $USING_PHYSICAL_DEVICE
  Frank::Cucumber::FrankHelper.test_on_physical_device_via_bonjour

  After do
    step 'I ask the app to reset to home'
  end
end

if !$USING_PHYSICAL_DEVICE && !ENV['DONT_INITIALLY_LAUNCH']
  # ensure app is initially launched
  launcher = Object.new.extend(Frank::Cucumber::FrankHelper).extend(Frank::Cucumber::Launcher)
  launcher.launch_app APP_BUNDLE_PATH 
end
