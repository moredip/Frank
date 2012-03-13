Given /^I launch the app$/ do

  require 'sim_launcher'

  app_path = ENV['APP_BUNDLE_PATH'] || APP_BUNDLE_PATH
  raise "APP_BUNDLE_PATH was not set. \nPlease set a APP_BUNDLE_PATH ruby constant or environment variable to the path of your compiled Frankified iOS app bundle" if app_path.nil?

  if( ENV['USE_SIM_LAUNCHER_SERVER'] )
    simulator = SimLauncher::Client.for_iphone_app( app_path )
  else
    simulator = SimLauncher::DirectClient.for_iphone_app( app_path )
  end


  # kill the app if it's already running, just in case this helps 
  # reduce simulator flakiness when relaunching the app. Use a timeout of 5 seconds to 
  # prevent us hanging around for ages waiting for the ping to fail if the app isn't running.
  #
  # We sleep for a second after pressing home to give the app time to quit, otherwise it can fail to immediately re-launch when asked to do some 
  # immediately below.
  begin
    Timeout::timeout(5) { (press_home_on_simulator and sleep 1) if frankly_ping }
  rescue Timeout::Error 
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
