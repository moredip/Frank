def discover_latest_sdk_version
  latest_iphone_sdk = `xcodebuild -showsdks | grep -o "iphoneos.*$"`.chomp
  version_part = latest_iphone_sdk[/iphoneos(.*)/,1]
  version_part
end

desc "Build the arm library"
task :build_iphone_lib do
  sh "xcodebuild -workspace Frank.xcworkspace -scheme Frank -configuration Release -sdk iphoneos#{discover_latest_sdk_version} BUILD_DIR=build clean build"
end

desc "Build the i386 library"
task :build_simulator_lib do
  sh "xcodebuild -workspace Frank.xcworkspace -scheme Frank -configuration Release -sdk iphonesimulator#{discover_latest_sdk_version} BUILD_DIR=build clean build"
end

task :combine_libraries do
  `lipo -create -output "dist/libFrank.a" "build/Release-iphoneos/libFrank.a" "build/Release-iphonesimulator/libFrank.a"`
  `lipo -create -output "dist/libCocoaHTTPServer.a" "build/Release-iphoneos/libCocoaHTTPServer.a" "build/Release-iphonesimulator/libCocoaHTTPServer.a"`
end

desc "Build a univeral library for both iphone and iphone simulator"
task :build_lib => [:build_iphone_lib,:build_simulator_lib,:combine_libraries]

desc "clean build artifacts"
task :clean do
  rm_rf 'dist'
end

desc "create dist directory"
task :prep_dist do
  mkdir_p 'dist'
end

task :build => [:clean, :prep_dist, :build_lib, :build_shelley]
task :default => :build

desc "compile libShelley.a and copy it into dist"
task :build_shelley do
  sh 'cd lib/Shelley && rake build_lib'
  sh 'cp lib/Shelley/build/libShelley.a dist/'
end

desc "build and copy everything into the gem directories for distribution as a gem"
task :build_for_release => [:build, :build_shelley, :copy_dist_to_gem]

desc "copies contents of dist dir to the frank-cucumber gem's frank-skeleton"
task :copy_dist_to_gem do
  sh "cp -r dist/* gem/frank-skeleton/"
end
