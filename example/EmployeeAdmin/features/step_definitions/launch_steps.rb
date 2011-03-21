Given /^I launch the app$/ do

  # kill the app if it's already running, just in case this helps 
  # reduce simulator flakiness when relaunching the app. Use a timeout of 5 seconds to 
  # prevent us hanging around for ages waiting for the ping to fail if the app isn't running
  begin
    Timeout::timeout(5) { press_home_on_simulator if frankly_ping }
  rescue Timeout::Error 
  end

  require 'sim_launcher'

  # Replace EmployeeAdmin.app to the application unders test
  app_path = File.dirname(__FILE__) + "/../../FrankDeploy/EmployeeAdmin.app"

  raise "APP_BUNDLE_PATH was not set. \nPlease set a APP_BUNDLE_PATH ruby constant or environment variable to the path of your compiled Frankified iOS app bundle" if app_path.nil?

  if( ENV['USE_SIM_LAUNCHER_SERVER'] )
    simulator = SimLauncher::Client.for_iphone_app( app_path, "4.2" )
  else
    simulator = SimLauncher::DirectClient.for_iphone_app( app_path, "4.2" )
  end
  
  num_timeouts = 0
  loop do
    begin
      simulator.relaunch
      wait_for_frank_to_come_up
      break # if we make it this far without an exception then we're good to move on

    rescue Timeout::Error
      num_timeouts += 1
      puts "Encountered #{num_timeouts} timeouts while launching the app."
      if num_timeouts > 3
        raise "Encountered #{num_timeouts} timeouts in a row while trying to launch the app." 
      end
    end
  end

  # TODO: do some kind of waiting check to see that your initial app UI is ready
  # e.g. Then "I wait to see the login screen"

end
