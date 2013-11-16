require 'sim_launcher'
require 'frank-cucumber/app_bundle_locator'
require 'frank-cucumber/frank_helper'

module Frank module Cucumber

module Launcher
    include Frank::Cucumber::FrankHelper

  attr_accessor :application_path, :sdk, :version

  def simulator_client
    @simulator_client ||= SimLauncher::Client.new(@application_path, @sdk, @version)
  end

  def simulator_direct_client
    @simulator_direct_client ||= SimLauncher::DirectClient.new(@application_path, @sdk, @version)
  end

  def enforce(app_path, locator = Frank::Cucumber::AppBundleLocator.new)
    if app_path.nil?
      message = "APP_BUNDLE_PATH is not set. \n\nPlease set APP_BUNDLE_PATH (either an environment variable, or the ruby constant in support/env.rb) to the path of your Frankified target's iOS app bundle."
      possible_app_bundles = locator.guess_possible_app_bundles_for_dir( Dir.pwd )
      if possible_app_bundles && !possible_app_bundles.empty?
        message << "\n\nBased on your current directory, you probably want to use one of the following paths for your APP_BUNDLE_PATH:\n"
        message << possible_app_bundles.join("\n")
      end
      raise "\n\n"+("="*80)+"\n"+message+"\n"+("="*80)+"\n\n"
    end

    if app_path_problem = SimLauncher.check_app_path(app_path)
      raise "\n\n"+("="*80)+"\n"+app_path_problem+"\n"+("="*80)+"\n\n"
    end
  end

  def launch_app(app_path, sdk = nil, version = 'iphone', wait_for_launch = true)
    @application_path = app_path
    @sdk = sdk
    @version = version

    if path_is_mac_app(@application_path)
      launch_mac_app(wait_for_launch)
    else
      enforce(app_path)
      launch_ios_app(wait_for_launch)
    end
  end

  def launch_ios_app(wait_for_launch = true)
    # kill the app if it's already running, just in case this helps
    # reduce simulator flakiness when relaunching the app. Use a timeout of 5 seconds to
    # prevent us hanging around for ages waiting for the ping to fail if the app isn't running
    begin
      Timeout::timeout(5) { press_home_on_simulator if frankly_ping }
    rescue Timeout::Error
    end

    if( ENV['USE_SIM_LAUNCHER_SERVER'] )
      simulator = simulator_client
    else
      simulator = simulator_direct_client
    end

    num_timeouts = 0
    begin
      simulator.relaunch

      if wait_for_launch
        wait_for_frank_to_come_up
      end
    rescue Timeout::Error
      num_timeouts += 1
      puts "Encountered #{num_timeouts} timeouts while launching the app."
      if num_timeouts > 3
        raise "Encountered #{num_timeouts} timeouts in a row while trying to launch the app."
      end
      quit_double_simulator
      retry
    end

  end

  def path_is_mac_app (app_dir)
    return File.exists? File.join( app_dir, "Contents", "MacOS" )
  end


  def launch_mac_app(wait_for_launch = true)
    `open "#{@application_path}"`

    if wait_for_launch
      wait_for_frank_to_come_up
    end
  end

  def quit_mac_app_if_running
    pid = `ps -ax | grep "#{@app_path}" | grep -v grep`

    if pid != ""
      pid = pid.strip.split[0]
      `kill #{pid}`
    end

    Timeout::timeout(60) {
      while pid != ""
        pid = `ps -ax | grep "#{@app_path}" | grep -v grep`
      end
    }

  end

  def relaunch_mac_app
    self.quit_if_running
    self.launch
  end

end
end end
