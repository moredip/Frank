require File.expand_path( '../gem/lib/frank-cucumber/version', __FILE__ )
PRODUCT_VERSION=Frank::Cucumber::VERSION

def discover_latest_sdk_for(platform)
  `xcodebuild -showsdks | grep -o "#{platform}.*$" | sort | tail -n 1`.chomp
end

def build_dir
  File.expand_path( '../build', __FILE__ )
end

def build_library(scheme, sdk)
  puts "building #{{scheme:scheme,sdk:sdk}}"
  preprocessor_flag = %Q|GCC_PREPROCESSOR_DEFINITIONS='$(inherited) SHELLEY_PRODUCT_VERSION=\"#{PRODUCT_VERSION}\" FRANK_PRODUCT_VERSION=\"#{PRODUCT_VERSION}\"'|
  sh "xcodebuild -workspace Frank.xcworkspace -scheme #{scheme} -configuration Release -sdk #{sdk} BUILD_DIR=\"#{build_dir}\" #{preprocessor_flag} clean build"
end

desc "Build the Mac library"
task :build_mac_lib do
  build_library('FrankMac', discover_latest_sdk_for('macosx'))
  sh "cp #{build_dir}/Release/*Mac.a dist"
end

def build_ios_library(platform)
  build_library('Frank',discover_latest_sdk_for(platform))
end

desc "Build the arm library"
task :build_iphone_lib do
  build_ios_library('iphoneos')
end

desc "Build the i386 library"
task :build_simulator_lib do
  build_ios_library('iphonesimulator')
end

task :combine_libraries do
  `lipo -create -output "dist/libFrank.a" "#{build_dir}/Release-iphoneos/libFrank.a" "#{build_dir}/Release-iphonesimulator/libFrank.a"`
  `lipo -create -output "dist/libCocoaHTTPServer.a" "#{build_dir}/Release-iphoneos/libCocoaHTTPServer.a" "#{build_dir}/Release-iphonesimulator/libCocoaHTTPServer.a"`
  `lipo -create -output "dist/libCocoaAsyncSocket.a" "#{build_dir}/Release-iphoneos/libCocoaAsyncSocket.a" "#{build_dir}/Release-iphonesimulator/libCocoaAsyncSocket.a"`
  `lipo -create -output "dist/libCocoaLumberjack.a" "#{build_dir}/Release-iphoneos/libCocoaLumberjack.a" "#{build_dir}/Release-iphonesimulator/libCocoaLumberjack.a"`
  `lipo -create -output "dist/libShelley.a" "#{build_dir}/Release-iphoneos/libShelley.a" "#{build_dir}/Release-iphonesimulator/libShelley.a"`
end

desc "Build a univeral library for both iphone and iphone simulator"
task :build_ios_lib => [:build_iphone_lib, :build_simulator_lib, :combine_libraries]

desc "Build both universal iOS lib and OS X lib"
task :build_lib => [:build_ios_lib, :build_mac_lib]

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
task :build_ios_only => [:clean, :prep_dist, :build_ios_lib, :bundle_resources]

task :default => :build

desc "build and copy everything into the gem directories for distribution as a gem"
task :build_for_release => [:build, :copy_dist_to_gem]

desc "copies contents of dist dir to the frank-cucumber gem's frank-skeleton"
task :copy_dist_to_gem do
  sh "cp -r dist/* gem/frank-skeleton/"
end
