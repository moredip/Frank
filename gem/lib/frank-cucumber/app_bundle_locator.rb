module Frank module Cucumber
  class XCode4Project
    def initialize( workspace_path, derived_dir )
      @workspace_path, @derived_dir = workspace_path, derived_dir 
    end

    def derived_name
      File.basename( @derived_dir )
    end

    def project_name
      derived_name.split('-')[0]
    end

    def workspace_dir
      File.dirname( @workspace_path )
    end

    def available_app_bundles
      Dir.glob( File.join( @derived_dir, "Build", "Products", "*", "*.app" ) )
    end

  end

  # utility class which will find all XCode4 projects which are using DerivedData to store their
  # build output, and present information about those projects
  class AppBundleLocator
    def initialize
      @projects = find_all_known_xcode_projects
    end

    def find_all_known_xcode_projects
      require 'plist'

      projects = []
      Dir.glob( File.expand_path( "~/Library/Developer/Xcode/DerivedData/*/info.plist" ) ) do |plist_path|
        workspace_path = Plist::parse_xml(plist_path)['WorkspacePath']
        projects << XCode4Project.new( workspace_path, File.dirname(plist_path) )
      end
      projects
    end

    def guess_possible_app_bundles_for_dir( dir )
      return [] if dir == '/'

      project = @projects.find do |project|
        project.workspace_dir == dir
      end

      if project.nil?
        return guess_possible_app_bundles_for_dir( File.dirname(dir) )
      end

      return project.available_app_bundles
    end

  end
end end
