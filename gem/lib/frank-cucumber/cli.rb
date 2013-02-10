begin 
  require 'pry'
rescue LoadError 
end

require 'thor'
require 'tmpdir'
require 'frank-cucumber/launcher'
require 'frank-cucumber/console'
require 'frank-cucumber/configuration'
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
    method_option :build_configuration, :aliases => '--conf', :type => :string
    def setup
      build_configuration = options[:build_configuration] || configuration.xcode.configuration
      @without_http_server = options[WITHOUT_SERVER] || configuration.xcode.without_cocoa_http_server

      # Copy features directory
      directory "./features", configuration.locations.features

      # Copy build files, based on configuration
      copy_build_file_paths build_file_paths_to_copy(@without_http_server)

      frankify_app build_configuration
    end

    desc "update", "updates the frank server components inside your Frank directory"
    method_option WITHOUT_SERVER, :type => :boolean
    method_option :build_configuration, :aliases => '--conf', :type => :string
    long_desc "This updates the parts of Frank that are embedded inside your app (e.g. libFrank.a and frank_static_resources.bundle)"
    def update
      build_configuration = options[:build_configuration] || configuration.xcode.configuration
      @without_http_server = options[WITHOUT_SERVER] || configuration.xcode.without_cocoa_http_server

      # Copy build files, forcing the copy when there is a conflict:
      copy_build_file_paths build_file_paths_to_copy(@without_http_server), true

      frankify_app build_configuration
    end

    XCODEBUILD_OPTIONS = %w{workspace scheme target}
    desc "build", "builds a Frankified version of your native app"
    XCODEBUILD_OPTIONS.each do |option|
      method_option option
    end
    method_option 'arch', :type => :string, :default => 'i386'
    method_option :noclean, :type => :boolean, :default => false, :aliases => '--nc', :desc => "Don't clean the build directory before building"
    method_option :build_configuration, :aliases => '--conf', :type => :string
    def build
      build_configuration = options[:build_configuration] || configuration.xcode.configuration
      clean = !options['noclean']

      in_root do
        unless File.directory? configuration.locations.features
          if yes? "You don't appear to have set up the Frank directory (#{configuration.locations.features}) for this project. Would you like me to set that up now? Type 'y' or 'yes' if so."
            invoke :skeleton
          else
            say "OK, in that case there's not much I can do for now. Whenever you change your mind and want to get your project setup with Frank simply run `frank setup` from the root of your project directory."
            say "Bye bye for now!"
            exit 11
          end
        end
      end

      if configuration.xcode.configuration && configuration.xcode.project && configuration.xcode.target
        # We have enough information to automatically frankify the project, so lets
        # do so to make sure the project is up to scratch for the configuration
        # we are about to build
        say 'Sufficient configuration information provided to automatically Frankify target.'
        frankify_app build_configuration
        say ''
      end

      if clean
        remove_dir build_output_dir
      end

      build_steps = 'build'
      if clean
        build_steps = 'clean ' + build_steps
      end

      modified_options = options.dup # options are frozen so we need to work with a duplicate
      modified_options['workspace'] ||= configuration.xcode.workspace
      modified_options['scheme'] ||= configuration.xcode.scheme

      extra_opts = XCODEBUILD_OPTIONS.map{ |o| "-#{o} \"#{modified_options[o]}\"" if modified_options[o] }.compact.join(' ')
      extra_opts += " -arch #{options['arch']}"

      run %Q|xcodebuild -xcconfig #{xconfig_path} #{build_steps} #{extra_opts} -configuration "#{build_configuration}" -sdk iphonesimulator DEPLOYMENT_LOCATION=YES DSTROOT="#{build_output_dir}" FRANK_LIBRARY_SEARCH_PATHS="\\"#{frank_lib_directory}\\""|

      FileUtils.mkdir_p(build_output_dir) # Directory may not exist yet
      app = Dir.glob("#{build_output_dir}/*.app").delete_if { |x| x =~ /\/#{app_bundle_name}$/ }
      app = app.first

      FileUtils.cp_r("#{app}/.", frankified_app_dir)

      fix_frankified_apps_bundle_identifier

      in_root do
        FileUtils.cp_r( 
          static_bundle_path,
          File.join( frankified_app_dir, 'frank_static_resources.bundle' ) 
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

    def configuration
      @configuration ||= Frank::Configuration.new
    end

    def build_file_paths_to_copy(without_http_server=false)
      if configuration.create_build_files_directory?
        copy_build_files = configuration.copy_build_files

        {
          'frank_static_resources.bundle/' => copy_build_files.bundle,
          'libFrank.a' => copy_build_files.libraries,
          'libShelley.a' => copy_build_files.libraries,
          'libCocoaHTTPServer.a' => copy_build_files.libraries && !without_http_server,
          'frankify.xcconfig.tt' => copy_build_files.xcconfig
        }
      else
        false
      end
    end

    def copy_build_file_paths(paths, force_copy=false)
      locations = configuration.locations

      if paths
        paths.each do |path, copy_or_subpaths|
          source_path = File.join('./build_files', path)
          destination_path = locations.build_files.join(path)
          if copy_or_subpaths
            force = force_copy && path !~ /\.xcconfig/ # We don't want to force an override of the xcconfig
            if path =~ /\/$/
              # Treat as a directory
              directory source_path, destination_path
            elsif path =~ /\.tt$/
              # Treat as template
              template source_path, destination_path.to_s.gsub(/\.tt$/, '')
            else
              # Treat as normal file
              copy_file source_path, destination_path
            end
          else
            # Don't copy path, remove it instead (remove_file works for directories too)
            remove_file destination_path if File.exists? destination_path
          end
        end
      else
        remove_dir locations.build_files if File.exists? locations.build_files
      end
    end

    def frankify_app(build_configuration)
      Frankifier.frankify!( configuration.locations.root, :build_config => build_configuration, :frank_config => configuration )
    end

    def xconfig_path
      if configuration.copy_build_files.xconfig
        File.join(configuration.locations.build_files, 'frankify.xcconfig')
      else
        # Copy the config (with template processed) into a temporary directory
        temp_config_path = File.join(Dir.tmpdir, 'frankify.xcconfig')
        template File.join('./build_files', 'frankify.xcconfig.tt'), temp_config_path, :force => true
        temp_config_path
      end
    end

    def static_bundle_path
      if configuration.copy_build_files.xconfig
        File.join(configuration.locations.build_files, 'frank_static_resources.bundle')
      else
        File.join(self.class.source_root, 'build_files', 'frank_static_resources.bundle')
      end
    end

    def product_name
      "Frankified"
    end

    def app_bundle_name
      "#{product_name}.app"
    end
    
    def frank_lib_directory
      if configuration.copy_build_files.libraries
        configuration.locations.build_files
      else
        File.join(self.class.source_root, 'build_files')
      end
    end

    def build_output_dir
      configuration.locations.build_output
    end

    def frankified_app_dir
      File.join( build_output_dir, app_bundle_name )
    end

    def fix_frankified_apps_bundle_identifier
      # as of iOS 6 the iOS Simulator locks up with a black screen if you try and launch an app which has the same
      # bundle identifier as a previously installed app but which is in fact a different app. This impacts us because our 
      # Frankified app is different but has the same bundle identifier as the standard non-Frankified app which most users
      # will want to have installed in the simulator as well. 
      #
      # We work around this by modifying the Frankified app's bundle identifier inside its Info.plist.
      inside frankified_app_dir do
        existing_bundle_identifier = `/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' Info.plist`.chomp
        new_bundle_identifier = existing_bundle_identifier + '.frankified'
        run %Q|/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier #{new_bundle_identifier}' Info.plist|
        run %Q|/usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName Frankified' Info.plist|
      end
    end

  end
end

