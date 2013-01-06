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
    method_option :build_configuration, :aliases=>'--conf', :type=>:string, :default => 'Debug'
    def setup
      @without_http_server = options[WITHOUT_SERVER] || configuration.xcode.without_cocoa_http_server

      locations = configuration.locations

      directory "./features", locations.features

      if configuration.create_build_files_directory?
        copy_build_files = configuration.copy_build_files
        build_files_source_path = Pathname.new('./build_files')
        if copy_build_files.bundle
          directory build_files_source_path.join('frank_static_resources.bundle'), 
                    File.join(locations.build_files, 'frank_static_resources.bundle')
        else
          remove_dir File.join(locations.build_files, 'frank_static_resources.bundle') if File.join(locations.build_files, 'frank_static_resources.bundle')
        end

        if copy_build_files.libraries
          %w{libFrank.a libShelley.a}.each do |library|
            copy_file build_files_source_path.join(library), 
                      File.join(locations.build_files, library)
          end

          if @without_http_server
            remove_file File.join(locations.build_files, 'libCocoaHTTPServer.a') if File.exists?(File.join(locations.build_files, 'libCocoaHTTPServer.a'))
          else
            copy_file build_files_source_path.join('libCocoaHTTPServer.a'), 
                      File.join(locations.build_files, 'libCocoaHTTPServer.a')
          end
        else
          %w{libFrank.a libShelley.a libCocoaHTTPServer.a}.each do |library|
            remove_file File.join(locations.build_files, library) if File.exists?(File.join(locations.build_files, library))
          end
        end

        if copy_build_files.xcconfig
          template build_files_source_path.join('frankify.xcconfig.tt'), 
                   File.join(locations.build_files, 'frankify.xcconfig')
        else
          remove_file File.join(locations.build_files, 'frankify.xcconfig') if File.exists?(File.join(locations.build_files, 'frankify.xcconfig'))
        end
      else
        if locations.features != locations.build_files
          remove_dir locations.build_files if File.exists?(locations.build_files)
        end
      end

      Frankifier.frankify!( locations.root, :build_config => options[:build_configuration], :frank_config => configuration )
    end

    desc "update", "updates the frank server components inside your Frank directory"
    method_option WITHOUT_SERVER, :type => :boolean
    long_desc "This updates the parts of Frank that are embedded inside your app (e.g. libFrank.a and frank_static_resources.bundle)"
    def update
      @without_http_server = options[WITHOUT_SERVER] || configuration.xcode.without_cocoa_http_server

      copy_build_files = configuration.copy_build_files
      locations = configuration.locations
      build_files_source_path = Pathname.new('./build_files')

      if configuration.create_build_files_directory?
        if copy_build_files.bundle
          directory build_files_source_path.join('frank_static_resources.bundle'), 
                    File.join(locations.build_files, 'frank_static_resources.bundle'), :force => true
        else
          remove_file File.join(locations.build_files, 'frankify.xcconfig') if File.exists?(File.join(locations.build_files, 'frankify.xcconfig'))
        end

        if copy_build_files.libraries
          %w{libFrank.a libShelley.a}.each do |f|
            copy_file build_files_source_path.join(f), 
                      File.join( configuration.locations.build_files, f ), :force => true
          end

          if @without_http_server
            remove_file File.join(locations.build_files, 'libCocoaHTTPServer.a') if File.exists?(File.join(locations.build_files, 'libCocoaHTTPServer.a'))
          else
            copy_file build_files_source_path.join('libCocoaHTTPServer.a'), 
                      File.join(locations.build_files, 'libCocoaHTTPServer.a'), :force => true
          end
        else
          %w{libFrank.a libShelley.a libCocoaHTTPServer.a}.each do |library|
            remove_file File.join(locations.build_files, library) if File.exists?(File.join(locations.build_files, library))
          end
        end

        if copy_build_files.xcconfig
          template build_files_source_path.join('frankify.xcconfig.tt'), 
                   File.join(locations.build_files, 'frankify.xcconfig')
        else
          remove_file File.join(locations.build_files, 'frankify.xcconfig') if File.exists?(File.join(locations.build_files, 'frankify.xcconfig'))
        end
      else
        remove_dir locations.build_files if File.exists?(locations.build_files)
      end
    end

    XCODEBUILD_OPTIONS = %w{workspace scheme target}
    desc "build", "builds a Frankified version of your native app"
    XCODEBUILD_OPTIONS.each do |option|
      method_option option
    end
    method_option 'arch', :type => :string, :default => 'i386'
    method_option :noclean, :type => :boolean, :default => false, :aliases => '--nc', :desc => "Don't clean the build directory before building"
    def build
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

      if clean
        remove_dir build_output_dir
      end

      build_steps = 'build'
      if clean
        build_steps = 'clean ' + build_steps
      end

      modified_options = options.dup
      if configuration.xcode.workspace && modified_options['workspace'].nil?
        modified_options['workspace'] = configuration.xcode.workspace
      end

      if configuration.xcode.scheme && modified_options['scheme'].nil?
        modified_options['scheme'] = configuration.xcode.scheme
      end

      extra_opts = XCODEBUILD_OPTIONS.map{ |o| "-#{o} \"#{modified_options[o]}\"" if modified_options[o] }.compact.join(' ')
      extra_opts += " -arch #{options['arch']}"

      run %Q|xcodebuild -xcconfig #{xconfig_path} #{build_steps} #{extra_opts} -configuration Debug -sdk iphonesimulator DEPLOYMENT_LOCATION=YES DSTROOT="#{build_output_dir}" FRANK_LIBRARY_SEARCH_PATHS="\\"#{frank_lib_directory}\\""|

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
      File.join(configuration.locations.build_files, "frankified_build")
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

