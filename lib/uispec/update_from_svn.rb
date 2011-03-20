require 'tmpdir'

SVN_URL = "http://uispec.googlecode.com/svn/trunk"

dest_dir = File.expand_path(File.dirname(__FILE__))

Dir.mktmpdir('frank_is_updating_uispec') do |tmpdir|
  snapshot_dir = File.join( tmpdir, "svn_snapshot" )
  puts `svn export #{SVN_URL} #{snapshot_dir}`
  FileUtils.cp_r( Dir.glob( File.join( snapshot_dir, "src", "*" )),  dest_dir )

  puts "\n"*3
  puts "uispec source files copied to current dir"
end
