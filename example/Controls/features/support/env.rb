require 'frank-cucumber'

Frank::Cucumber::FrankHelper.use_shelley_from_now_on

$USING_PHYSICAL_DEVICE = !!ENV['USE_PHYSICAL_DEVICE']

if $USING_PHYSICAL_DEVICE
  Frank::Cucumber::FrankHelper.test_on_physical_device_via_bonjour

  After do
    step 'I ask the app to reset to home'
  end
end

