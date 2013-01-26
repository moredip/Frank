require 'frank-cucumber/rect'
require 'frank-cucumber/color_helper'
require 'frank-cucumber/frank_helper'
require 'frank-cucumber/frank_mac_helper'
require 'frank-cucumber/launcher'
require 'frank-cucumber/mac_launcher'

World(Frank::Cucumber::ColorHelper)
World(Frank::Cucumber::FrankHelper)
World(Frank::Cucumber::Launcher)

AfterConfiguration do
  require 'frank-cucumber/core_frank_steps'
end
