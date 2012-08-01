begin 
  require 'pry'
rescue LoadError 
end

require 'thor'
require 'frank-cucumber/launcher'
require 'frank-cucumber/console'
require 'frank-cucumber/frankifier'

module Frank
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.join( File.dirname(__FILE__), '..','..','frank-skeleton' )
    end

    # included just because the old setup script was called frank-skeleton
    desc "skeleton", "an alias for setup"
    def skeleton
      invoke :setup
    end

    WITHOUT_SERVER = "without-cocoa-http-server"
    desc "setup", "set up your iOS app by adding a Frank subdirectory containing everything Frank needs"
    method_option WITHOUT_SERVER, :type => :boolean
    def setup
      @without_http_server = options[WITHOUT_SERVER]

      directory ".", "Frank"

      Frankifier.frankify!( File.expand_path('.') )
    end

    desc "update", "updates the frank server components inside your Frank directory"
    long_desc "This updates the parts of Frank that are embedded inside your app (e.g. libFrank.a and frank_static_resources.bundle)"
    def update
      %w{libFrank.a libShelley.a}.each do |f|
        copy_file f, File.join( 'Frank', f ), :force => true
      end
      directory( 'frank_static_resources.bundle', 'Frank/frank_static_resources.bundle', :force => true )
    end

    XCODEBUILD_OPTIONS = %w{workspace scheme target}
    desc "build", "builds a Frankified version of your native app"
    XCODEBUILD_OPTIONS.each do |option|
      method_option option
    end
    def build

      in_root do
        unless File.directory? 'Frank'
          if yes? "You don't appear to have set up a Frank directory for this project. Would you like me to set that up now? Type 'y' or 'yes' if so."
            invoke :skeleton
          else
            say "OK, in that case there's not much I can do for now. Whenever you change your mind and want to get your project setup with Frank simply run `frank setup` from the root of your project directory."
            say "Bye bye for now!"
            exit 11
          end
        end
      end

      static_bundle = 'frank_static_resources.bundle'

      remove_dir build_output_dir

      extra_opts = XCODEBUILD_OPTIONS.map{ |o| "-#{o} #{options[o]}" if options[o] }.compact.join(' ')

      run %Q|xcodebuild -xcconfig Frank/frankify.xcconfig clean build #{extra_opts} -configuration Debug -sdk iphonesimulator DEPLOYMENT_LOCATION=YES DSTROOT="#{build_output_dir}" FRANK_LIBRARY_SEARCH_PATHS="\\"#{frank_lib_directory}\\""|

      FileUtils.mv( Dir.glob( "#{build_output_dir}/*.app" ).first, frankified_app_dir )

      in_root do
        FileUtils.cp_r( 
          File.join( 'Frank',static_bundle),
          File.join( frankified_app_dir, static_bundle ) 
        )
      end
    end

    desc "build_and_launch", "rebuild a Frankfied version of your app then launch"
    def build_and_launch
      invoke :build
      invoke :launch
    end

    desc "launch", "open the Frankified app in the simulator"
    method_option :debug, :type => :boolean, :default => false
    method_option :idiom, :banner => 'iphone|ipad', :type => :string, :default => (ENV['FRANK_SIM_IDIOM'] || 'iphone')
    def launch
      $DEBUG = options[:debug]
      launcher = case options[:idiom].downcase
      when 'iphone'
        SimLauncher::DirectClient.for_iphone_app( frankified_app_dir )
      when 'ipad'
        SimLauncher::DirectClient.for_ipad_app( frankified_app_dir )
      else
        say "idiom must be either iphone or ipad. You supplied '#{options[:idiom]}'", :red
        exit 10
      end

      in_root do
        unless File.exists? frankified_app_dir
          say "A Frankified version of the app doesn't appear to have been built. Building one now"
          say "..."
          invoke :build
        end

        say "LAUNCHING IN THE SIMULATOR..."

        launcher.relaunch
      end
    end

    desc "inspect", "launch Symbiote in the browser"
    long_desc "launch Symbiote in the browser so you can inspect the live state of your Frankified app"
    def inspect
      # TODO: check whether app is running (using ps or similar), and launch it if it's not
      run 'open http://localhost:37265'
    end

    desc 'console', "launch a ruby console connected to your Frankified app"
    def console
      # TODO: check whether app is running (using ps or similar), and launch it if it's not
      
      begin
        require 'pry'
      rescue LoadError
        say 'The Frank console requires the pry gem.'
        say 'Simply run `sudo gem install pry` (the `sudo` bit might be optional), and then try again. Thanks!'
        exit 41 
      end
  
      Frank::Cucumber::FrankHelper.use_shelley_from_now_on
      console = Frank::Console.new
      if console.check_for_running_app
        console.pry
      end
    end

    private

    def product_name
      "Frankified"
    end

    def app_bundle_name
      "#{product_name}.app"
    end
    
    def frank_lib_directory
      File.expand_path "Frank"
    end

    def build_output_dir
      File.expand_path "Frank/frankified_build"
    end

    def frankified_app_dir
      File.join( build_output_dir, app_bundle_name )
    end

  end
end

