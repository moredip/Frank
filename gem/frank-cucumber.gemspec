# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "frank-cucumber/version"

Gem::Specification.new do |s|
  s.name        = "frank-cucumber"
  s.version     = Frank::Cucumber::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pete Hodgson","Derek Longmuir"]
  s.email       = ["gems@thepete.net"]
  s.homepage    = "http://rubygems.org/gems/frank-cucumber"
  s.summary     = %q{Use cucumber to test native iOS apps via Frank}
  s.description = %q{Use cucumber to test native iOS apps via Frank}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency( "cucumber" )
  s.add_dependency( "rspec", [">=2.0"] )
  s.add_dependency( "sim_launcher" )
  s.add_dependency( "json" ) # TODO: figure out how to be more permissive as to which JSON gems we allow
end
