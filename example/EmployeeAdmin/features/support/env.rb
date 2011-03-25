require 'frank-cucumber'

if %x[xcodebuild -version].include?( "Xcode 4")
	# In Xcode4 the path to the simulator seems to be magically managed by the IDE and no-longer relative to the project.
	#
	# You need to find this directory and set it here.
	#
	# 1. Build your Frankified project
	# 2. Set the filter to be "All Messages"
	# 3. Scroll to the bottom of the build log
	# 4. The last entry will be "Touch <a big long path>
	# 5. Expand the last entry by clicking the icon to the right of that line (looks like a button with 5 lines in it)
	# 6. The last line in the expanded entry will be "/usr/bin/touch -c <big path ending in:/Build/Products/Debug-iphonesimulator/EmployeeAdmin.app>"
	# 7. Change the APP_BUNDLE_PATH below to that value.
	
	APP_BUNDLE_PATH = "<big path ending in:/Build/Products/Debug-iphonesimulator/EmployeeAdmin.app>"
	if APP_BUNDLE_PATH.include?( "big path ending" )
		puts "\nERROR: You need to update your features/support/env.rb\nPlease see that file for further instructions.\n\n"
	end
else
   APP_BUNDLE_PATH = File.dirname(__FILE__) + "/../../build/Debug-iphonesimulator/EmployeeAdmin.app"
end
   
