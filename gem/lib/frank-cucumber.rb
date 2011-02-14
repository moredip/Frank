require 'frank-cucumber/color_helper'
require 'frank-cucumber/frank_helper'

World(Frank::Cucumber::ColorHelper)
World(Frank::Cucumber::FrankHelper)

AfterConfiguration do
  require 'frank-cucumber/core_frank_steps'
end
