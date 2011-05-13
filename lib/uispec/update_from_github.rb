#!/usr/bin/env ruby

require 'tmpdir'

GITHUB_TARBALL = "http://github.com/moredip/UISpec/tarball/frank_additions"

dest_dir = File.expand_path(File.dirname(__FILE__))

Dir.mktmpdir('frank_is_updating_uispec') do |tmpdir|
  `cd #{tmpdir}; curl -L #{GITHUB_TARBALL} | tar xzv`
  FileUtils.cp_r( Dir.glob( File.join( tmpdir, '*', "src", "*" )),  dest_dir )

  puts "\n"*3
  puts "uispec source files copied to current dir"
end
