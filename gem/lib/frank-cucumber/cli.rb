require 'thor'

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

    desc "setup", "set up your iOS app by adding a Frank subdirectory containing everything Frank needs"
    def setup
      directory ".", "Frank"
      say <<-EOS

      Frank subdirectory created.
      Your next step is to create a Frankified target for your app, and add the libFrank.a, libShelley.a and frank_static_resources.bundle files inside the Frank directory to that target.
      After that, you can build the target and try executing 'cucumber' from the Frank directory to see how your initial cucumber test runs.
      EOS
    end

    desc "update", "updates the frank server components inside your Frank directory"
    long_desc "This updates the parts of Frank that are embedded inside your app (e.g. libFrank.a and frank_static_resources.bundle)"
    def update
      %w{libFrank.a libShelley.a}.each do |f|
        copy_file f, File.join( 'Frank', f ), :force => true
      end
      directory( 'frank_static_resources.bundle', 'Frank/frank_static_resources.bundle', :force => true )
    end

    desc "build", "builds a Frankified version of your native application"
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

      app_bundle_name = "Frankified.app"
      build_output_dir = "Frank/frankified_build"
      static_bundle = 'frank_static_resources.bundle'

      remove_dir build_output_dir

      run "xcodebuild -xcconfig Frank/frankify.xcconfig install -configuration Debug -sdk iphonesimulator DSTROOT=#{build_output_dir} WRAPPER_NAME=#{app_bundle_name}"

      in_root do
        FileUtils.cp_r( 
          File.join( 'Frank',static_bundle),
          File.join( build_output_dir, app_bundle_name, static_bundle ) 
        )
      end
    end

  end

end

