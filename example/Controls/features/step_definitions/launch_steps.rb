Given /^I launch the app$/ do


  app_path = ENV['APP_BUNDLE_PATH'] || (defined?(APP_BUNDLE_PATH) && APP_BUNDLE_PATH)

  ####################
  # once you're setting APP_BUNDLE_PATH correctly you can get rid 
  # of this detection/reporting code if you want
  #
  if app_path.nil?
    require 'frank-cucumber/app_bundle_locator'
    message = "APP_BUNDLE_PATH is not set. \n\nPlease set APP_BUNDLE_PATH (either an environment variable, or the ruby constant in support/env.rb) to the path of your Frankified target's iOS app bundle."
    possible_app_bundles = Frank::Cucumber::AppBundleLocator.new.guess_possible_app_bundles_for_dir( Dir.pwd )
    if possible_app_bundles && !possible_app_bundles.empty?
      message << "\n\nBased on your current directory, you probably want to use one of the following paths for your APP_BUNDLE_PATH:\n"
      message << possible_app_bundles.join("\n")
    end

    raise "\n\n"+("="*80)+"\n"+message+"\n"+("="*80)+"\n\n"
  end
  #
  ####################



  # kill the app if it's already running, just in case this helps 
  # reduce simulator flakiness when relaunching the app. Use a timeout of 5 seconds to 
  # prevent us hanging around for ages waiting for the ping to fail if the app isn't running
  begin
    Timeout::timeout(5) { press_home_on_simulator if frankly_ping }
  rescue Timeout::Error 
  end


  require 'sim_launcher'

  if( ENV['USE_SIM_LAUNCHER_SERVER'] )
    simulator = SimLauncher::Client.for_iphone_app( app_path )
  else
    simulator = SimLauncher::DirectClient.for_iphone_app( app_path )
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
