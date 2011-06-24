Given /^I launch the app$/ do

  # kill the app if it's already running, just in case this helps 
  # reduce simulator flakiness when relaunching the app. Use a timeout of 5 seconds to 
  # prevent us hanging around for ages waiting for the ping to fail if the app isn't running
  begin
    Timeout::timeout(5) { press_home_on_simulator if frankly_ping }
  rescue Timeout::Error 
  end

  require 'sim_launcher'

  app_path = nil
        
  Dir.foreach(APPLICATIONS_DIR) do |item|
    next if item == '.' or item == '..'
    if File::exists?( "#{APPLICATIONS_DIR}/#{item}/#{APPNAME}.app")
        app_path = "#{APPLICATIONS_DIR}/#{item}/#{APPNAME}.app"
        break
    end
  end
      
  raise "Application was not set. \nPlease set ruby constant or environment variable in support/env.rb so the path of your compiled Frankified iOS app bundle can be found" if app_path.nil?

  if( ENV['USE_SIM_LAUNCHER_SERVER'] )
    simulator = SimLauncher::Client.for_iphone_app( app_path, "#{SDK_VERSION_MAJOR}#{SDK_VERSION_MINOR}" )
  else
    simulator = SimLauncher::DirectClient.for_iphone_app( app_path, "#{SDK_VERSION_MAJOR}#{SDK_VERSION_MINOR}" )
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
