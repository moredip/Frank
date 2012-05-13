require 'frank-cucumber'

# UIQuery is deprecated. Please use the shelley selector engine. 
Frank::Cucumber::FrankHelper.use_shelley_from_now_on

# TODO: set this constant to the full path for your Frankified target's app bundle.
# See the "Given I launch the app" step definition in launch_steps.rb for more details
APP_BUNDLE_PATH = nil
