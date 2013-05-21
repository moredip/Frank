require 'sim_launcher'
require 'frank-cucumber/app_bundle_locator'

module Frank module Cucumber

module Launcher 
  attr_accessor :application_path, :sdk, :version

  def simulator_client
    @simulator_client ||= SimLauncher::Client.new(@application_path, @options)
  end

  def simulator_direct_client
    @simulator_direct_client ||= SimLauncher::DirectClient.new(@application_path, @options)
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

  def launch_app(app_path, sdk = nil, version = 'iphone')
    launch_app_with_options(app_path, :sdk => sdk, :device => default_device_for_family(version))
  end

  # @param [String] app_path the app_path to launch.
  # @param [Hash] options the options to launch the app with.
  # @option options [String] :sdk the sdk version. Defaults to latest.
  # @option options [String] :device the device. Defaults to non-retina iphone.
  # @see https://github.com/moredip/Sim-Launcher SimLauncher::DeviceType for supported devices. 
  # @option options [String] :app_args arguments to pass to the app being launched.
  def launch_app_with_options(app_path, options = {})
    @application_path = app_path
    @options = options

    enforce(app_path)

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
      wait_for_frank_to_come_up
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

  def default_device_for_family( family )
    SimLauncher::DeviceType::Phone if family == SimLauncher::DeviceFamily::Phone
    SimLauncher::DeviceType::Pad if family == SimLauncher::DeviceFamily::Pad
  end
end
end end
