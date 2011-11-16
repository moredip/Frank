def discover_latest_sdk_version
  latest_iphone_sdk = `xcodebuild -showsdks | grep -o "iphoneos.*$"`.chomp
  version_part = latest_iphone_sdk[/iphoneos(.*)/,1]
  version_part
end

PRODUCT_NAME="Shelley"
WORKSPACE_PATH="#{PRODUCT_NAME}.xcodeproj/project.xcworkspace"
SCHEME=PRODUCT_NAME

def build_project_for(arch)
  sdk = arch+discover_latest_sdk_version
  sh "xcodebuild -workspace #{WORKSPACE_PATH} -scheme #{SCHEME} -configuration Release -sdk #{sdk} BUILD_DIR=build clean build"
end

desc "Build the arm library"
task :build_iphone_lib do
  build_project_for('iphoneos')
end

desc "Build the i386 library"
task :build_simulator_lib do
  build_project_for('iphonesimulator')
end

task :combine_libraries do
  lib_name = "lib#{PRODUCT_NAME}.a"
  `lipo -create -output "build/#{lib_name}" "build/Release-iphoneos/#{lib_name}" "build/Release-iphonesimulator/#{lib_name}"`
end

desc "Build a univeral library for both iphone and iphone simulator"
task :build_lib => [:build_iphone_lib,:build_simulator_lib,:combine_libraries]

task :default => :build_lib
