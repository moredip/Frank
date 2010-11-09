FRANK_LOCATION = "../../../Frank"

require File.join( File.dirname(__FILE__), "#{FRANK_LOCATION}/cucumber/frank_helper" )
require 'spec/expectations'

World(FrankHelper)
