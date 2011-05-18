require 'frank-cucumber/color_helper'
require 'frank-cucumber/frank_helper'
require 'frank-cucumber/bonjour'

World(Frank::Cucumber::ColorHelper)
World(Frank::Cucumber::FrankHelper)

AfterConfiguration do
  require 'frank-cucumber/core_frank_steps'

  require 'frank-cucumber/find_frank'
  $frank_base_uri = Frank.discover_frank_server_base_uri
end
