require 'thor'

module Frank
  class CLI < Thor
    include Thor::Actions

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


    def self.source_root
      File.join( File.dirname(__FILE__), '..','..','frank-skeleton' )
    end

    private


#def update_server_files
  #source_files = %w{libFrank.a libShelley.a frank_static_resources.bundle}.map{ |x| File.join( SOURCE_DIR, x ) }
  #FileUtils.cp_r( source_files, TARGET_DIR )
  #puts "All done. I've updated libFrank.a, libShelley.a and frank_static_resources.bundle inside #{TARGET_DIR}"
#end

#frank_dir_already_exists = File.exists?( TARGET_DIR ) 

#if frank_dir_already_exists && !update_mode
  #puts "A Frank subdirectory already exists. I don't want to mess with that. \n\nIf you want me to update the frank server code in that directory then run `frank-skeleton update-server`"
  #exit 1
#elsif !frank_dir_already_exists && update_mode
  #puts "There isn't a Frank subdirectory here for me to update.\n\nIf you want to create a new Frank subdirectory containing the Frank server code and an initial Cucumber setup then you should run `frank-skeleton` with no arguments"
  #exit 2
#end

  end

end

