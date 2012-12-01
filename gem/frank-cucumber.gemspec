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

  git_files = `git ls-files`.split("\n")
  symbiote_files = Dir[File.join('frank-skeleton','frank_static_resources.bundle','**','*')]
  s.files         = git_files+symbiote_files
  #puts s.files.join("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency( "cucumber" )
  s.add_dependency( "rspec", [">=2.0"] )
  s.add_dependency( "sim_launcher", [">=0.4.6"] )
  s.add_dependency( "i18n" )
  s.add_dependency( "plist" )
  s.add_dependency( "json" ) # TODO: figure out how to be more permissive as to which JSON gems we allow
  s.add_dependency( "dnssd" )
  s.add_dependency( "thor" )
  s.add_dependency( "xcodeproj" )

  s.add_development_dependency( "rr" )
  s.add_development_dependency( "yard" )
  s.add_development_dependency( "pry" )
  s.add_development_dependency( "pry-debugger" )
end
