require 'thor'

module Frank
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.join( File.dirname(__FILE__), '..','..','frank-skeleton' )
    end

    desc "skeleton", "set up your iOS app by adding a Frank subdirectory containing everything Frank needs"
    def skeleton
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

  end

end

