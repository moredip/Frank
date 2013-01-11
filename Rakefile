def discover_latest_ios_sdk_version
  latest_iphone_sdk = `xcodebuild -showsdks | grep -o "iphoneos.*$"`.chomp
  version_part = latest_iphone_sdk[/iphoneos(.*)/,1]
  version_part
end

def discover_latest_osx_sdk_version
  latest_osx_sdk = `xcodebuild -showsdks | grep -o "iphoneos.*$"`.chomp
  version_part = latest_osx_sdk[/macosx(.*)/,1]
  version_part
end

def build_dir
  File.expand_path 'build'
end

desc "Build the arm library"
task :build_iphone_lib do
  sh "xcodebuild -workspace Frank.xcworkspace -scheme Frank -configuration Release -sdk iphoneos#{discover_latest_ios_sdk_version} BUILD_DIR=\"#{build_dir}\" clean build"
end

desc "Build the i386 library"
task :build_simulator_lib do
  sh "xcodebuild -workspace Frank.xcworkspace -scheme Frank -configuration Release -sdk iphonesimulator#{discover_latest_ios_sdk_version} BUILD_DIR=\"#{build_dir}\" clean build"
end

desc "Build the Mac library"
task :build_mac_lib do
  sh "xcodebuild -workspace Frank.xcworkspace -scheme FrankMac -configuration Release -sdk macosx#{discover_latest_osx_sdk_version} BUILD_DIR=\"#{build_dir}\" clean build"
  sh "cp #{build_dir}/Release/*Mac.a dist"
end

task :combine_libraries do
  `lipo -create -output "dist/libFrank.a" "#{build_dir}/Release-iphoneos/libFrank.a" "#{build_dir}/Release-iphonesimulator/libFrank.a"`
  `lipo -create -output "dist/libCocoaHTTPServer.a" "#{build_dir}/Release-iphoneos/libCocoaHTTPServer.a" "#{build_dir}/Release-iphonesimulator/libCocoaHTTPServer.a"`
  `lipo -create -output "dist/libShelley.a" "#{build_dir}/Release-iphoneos/libShelley.a" "#{build_dir}/Release-iphonesimulator/libShelley.a"`
end

desc "Build a univeral library for both iphone and iphone simulator"
task :build_lib => [:build_iphone_lib, :build_simulator_lib, :combine_libraries, :build_mac_lib]

desc "clean build artifacts"
task :clean do
  rm_rf 'dist'
  rm_rf "#{build_dir}"
end

desc "create dist directory"
task :prep_dist do
  mkdir_p 'dist'
  mkdir_p "#{build_dir}"
end

desc "Package symbiote resource bundle"
task :bundle_resources do
  sh "cp -r symbiote/bundle dist/frank_static_resources.bundle"
end

task :build => [:clean, :prep_dist, :build_lib, :bundle_resources]
task :default => :build

desc "build and copy everything into the gem directories for distribution as a gem"
task :build_for_release => [:build, :build_shelley, :copy_dist_to_gem]

desc "copies contents of dist dir to the frank-cucumber gem's frank-skeleton"
task :copy_dist_to_gem do
  sh "cp -r dist/* gem/frank-skeleton/"
end
