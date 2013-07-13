begin
  require 'pry'
rescue LoadError
end

require 'thor'
require 'frank-cucumber/launcher'
require 'frank-cucumber/console'
require 'frank-cucumber/frankifier'
require 'frank-cucumber/mac_launcher'
require 'frank-cucumber/plugins/plugin'
require 'xcodeproj'

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
    WITHOUT_ASYNC_SOCKET = "without-cocoa-async-socket"
    WITHOUT_LUMBERJACK = "without-cocoa-lumberjack"
    desc "setup", "set up your iOS app by adding a Frank subdirectory containing everything Frank needs"
    method_option WITHOUT_SERVER, :type => :boolean
    method_option WITHOUT_ASYNC_SOCKET, :type => :boolean
    method_option WITHOUT_LUMBERJACK, :type => :boolean
    method_option :build_configuration, :aliases=>'--conf', :type=>:string, :default => 'Debug'
    method_option :target, :type=>:string
    method_option :project, :type=>:string
    def setup
      @libs = %w(Shelley CocoaAsyncSocket CocoaLumberjack CocoaHTTPServer Frank)
      @libsMac = %w(ShelleyMac CocoaAsyncSocketMac CocoaLumberjackMac CocoaHTTPServerMac FrankMac)
      @libs -= %w(CocoaHTTPServer) if options[WITHOUT_SERVER]
      @libsMac -= %w(CocoaHTTPServerMac) if options[WITHOUT_SERVER]
      @libs -= %w(CocoaAsyncSocket) if options[WITHOUT_ASYNC_SOCKET]
      @libsMac -= %w(CocoaAsyncSocketMac) if options[WITHOUT_ASYNC_SOCKET]
      @libs -= %w(CocoaLumberjack) if options[WITHOUT_LUMBERJACK]
      @libsMac -= %w(CocoaLumberjackMac) if options[WITHOUT_LUMBERJACK]
      directory ".", "Frank"

      Frankifier.frankify!( File.expand_path('.'), :build_config => options[:build_configuration], :target => options[:target], :project => options[:project] )
    end

    desc "update", "updates the frank server components inside your Frank directory"
    long_desc "This updates the parts of Frank that are embedded inside your app (e.g. libFrank.a and frank_static_resources.bundle)"
    def update
      %w{libFrank.a libCocoaAsyncSocket.a libCocoaLumberjack.a libCocoaHTTPServer.a libShelley.a libFrankMac.a libShelleyMac.a libCocoaAsyncSocketMac.a libCocoaLumberjackMac.a libCocoaHTTPServerMac.a}.each do |f|
        copy_file f, File.join( 'Frank', f ), :force => true
      end
      directory( 'frank_static_resources.bundle', 'Frank/frank_static_resources.bundle', :force => true )

      if yes? "\nOne or more static libraries may have been updated. For these changes to take effect the 'frankified_build' directory must be cleaned. Would you like me to do that now? Type 'y' or 'yes' to delete the contents of frankified_build."
        remove_file('Frank/frankified_build')
      end
    end

    XCODEBUILD_OPTIONS = %w{workspace project scheme target configuration}
    desc "build [<buildsetting>=<value>]...", "builds a Frankified version of your native app"
    XCODEBUILD_OPTIONS.each do |option|
      method_option option
    end

    WITHOUT_DEPS = 'without-dependencies'
    method_option 'no-plugins', :type => :boolean, :default => false, :aliases => '--np', :desc => 'Disable plugins'
    method_option 'arch', :type => :string, :default => 'i386'
    method_option :noclean, :type => :boolean, :default => false, :aliases => '--nc', :desc => "Don't clean the build directory before building"
    method_option WITHOUT_DEPS, :type => :array, :desc => 'An array (space separated list) of plugin dependencies to exclude'
    def build(*args)
      clean = !options['noclean']
      use_plugins = !options['no-plugins']
      exclude_dependencies = options[WITHOUT_DEPS] || []

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

      if clean
        remove_dir build_output_dir
      end

      build_steps = 'build'
      if clean
        build_steps = 'clean ' + build_steps
      end

      plugins = use_plugins ? gather_plugins : []

      say "Detected plugins: #{plugins.map {|p| p.name}.join(', ')}" unless plugins.empty?

      say "Excluding plugin dependencies: #{exclude_dependencies.join(', ')}" unless exclude_dependencies.empty?

      plugins.each {|plugin| plugin.write_xcconfig(exclude_dependencies)}

      xcconfig_data = Frank::Plugins::Plugin.generate_core_xcconfig(plugins)

      xcconfig_file = 'Frank/frank.xcconfig'
      File.open(xcconfig_file,'w') {|f| f.write(xcconfig_data) }

      extra_opts = XCODEBUILD_OPTIONS.map{ |o| "-#{o} \"#{options[o]}\"" if options[o] }.compact.join(' ')

      # If there is a scheme specified we don't want to inject the default configuration
      # If there is a configuration specified, we also do not want to inject the default configuration
      if options['scheme'] || options['configuration']
        separate_configuration_option = ""
      else
        separate_configuration_option = "-configuration Debug"
      end

      build_mac = determine_build_patform(options) == :osx

      xcodebuild_args = args.join(" ")

      if build_mac
        run %Q|xcodebuild -xcconfig #{xcconfig_file} #{build_steps} #{extra_opts} #{separate_configuration_option} DEPLOYMENT_LOCATION=YES DSTROOT="#{build_output_dir}" FRANK_LIBRARY_SEARCH_PATHS="#{frank_lib_search_paths}" #{xcodebuild_args}|
      else
        extra_opts += " -arch #{options['arch']}"

        run %Q|xcodebuild -xcconfig #{xcconfig_file} #{build_steps} #{extra_opts} #{separate_configuration_option} -sdk iphonesimulator DEPLOYMENT_LOCATION=YES DSTROOT="#{build_output_dir}" FRANK_LIBRARY_SEARCH_PATHS="#{frank_lib_search_paths}" #{xcodebuild_args}|
      end
      exit $?.exitstatus if not $?.success?

      app = Dir.glob("#{build_output_dir}/*.app").delete_if { |x| x =~ /\/#{app_bundle_name}$/ }
      app = app.first
      FileUtils.cp_r("#{app}/.", frankified_app_dir)

      if build_mac
        in_root do
          FileUtils.cp_r(
            File.join( 'Frank',static_bundle),
            File.join( frankified_app_dir, "Contents", "Resources", static_bundle )
          )
        end
      else
        fix_frankified_apps_bundle_identifier

        in_root do
          FileUtils.cp_r(
            File.join( 'Frank',static_bundle),
            File.join( frankified_app_dir, static_bundle )
          )
        end
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

        if built_product_is_mac_app( frankified_app_dir )
          launcher = Frank::MacLauncher.new( frankified_app_dir )
          say "LAUNCHING APP..."
        else
          say "LAUNCHING IN THE SIMULATOR..."
        end

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

    def frank_lib_search_paths
      paths = [frank_lib_directory]
      each_plugin_path do |path|
        paths << path
      end

      paths.map {|path| %Q[\\"#{path}\\"]}.join(' ')
    end

    def build_output_dir
      File.expand_path "Frank/frankified_build"
    end

    def frankified_app_dir
      File.join( build_output_dir, app_bundle_name )
    end

    def plugin_dir
      File.expand_path 'Frank/plugins'
    end

    def built_product_is_mac_app ( app_dir )
        return File.exists? File.join( app_dir, "Contents", "MacOS" )
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

    # The xcodeproj gem doesn't currently support schemes, and schemes have been difficult
    # to figure out. I plan to either implement schemes in xcodeproj at a later date, or
    # wait for them to be implemented, and then fix this function
    def determine_build_patform ( options )
      project_path = nil

      if options["workspace"] != nil
        if options["scheme"] != nil
          workspace = Xcodeproj::Workspace.new_from_xcworkspace(options["workspace"])
          projects = workspace.projpaths

          projects.each { | current_project |
            lines = `xcodebuild -project "#{current_project}" -list`

            found_schemes = false

            lines.split("\n").each { | line |
              if found_schemes
                line = line[8..-1]

                if line == ""
                  found_schemes = false
                else
                  if line == options["scheme"]
                    project_path = current_project
                  end
                end

              else
                line = line [4..-1]

                if line == "Schemes:"
                  found_schemes = true
                end

              end
            }
          }
        else
          say "You must specify a scheme if you specify a workplace"
          exit 10
        end
      else
        project_path = options["project"]
      end

      if project_path == nil
        Dir.foreach(Dir.pwd) { | file |
          if file.end_with? ".xcodeproj"
            if project_path != nil
              say "You must specify a project if there are more than one .xcodeproj bundles in a directory"
              exit 10
            else
              project_path = file
            end
          end
        }
      end

      project = Xcodeproj::Project.new(project_path)

      target = nil

      if options["target"] != nil
        project.targets.each { | proj_target |
          if proj_target.name == options["target"]
            target = proj_target
          end
        }
      else
        target = project.targets[0]
      end

      if target == nil
        say "Unable to determine a target from the options provided. Assuming iOS"
        return :ios
      end

      return target.platform_name

    end

    def each_plugin_path(&block)
      plugin_glob = File.join("#{plugin_dir}",'*')
      Dir[plugin_glob].map do |plugin_path|
        yield plugin_path
      end
    end

    def gather_plugins
      each_plugin_path do |plugin_path|
        Frank::Plugins::Plugin.from_plugin_directory(plugin_path)
      end
    end

  end
end

