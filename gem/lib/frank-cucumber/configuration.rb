require 'yaml'
require 'recursive_open_struct'
require 'active_support/core_ext/hash/deep_merge'

module Frank
  class Configuration
    def defaults
      {
        'copy_build_files' => {
          'bundle' => true,
          'libraries' => true,
          'xcconfig' => true
        },
        'locations' => {
          'features' => 'Frank/features',
          'build_files' => 'Frank'
        },
        'xcode' => {
          'without_cocoa_http_server' => false,
          'build_settings' => '',
          'project' => false,
          'target' => false,
          'workspace' => false,
          'scheme' => false,
          'configuration' => 'Debug'
        }
      }
    end

    def initialize
      frankrc_path = find_frankrc
      if frankrc_path
        @root_directory = File.dirname(frankrc_path)
        @configuration = YAML.load_file(frankrc_path)
      else
        @root_directory = Dir.pwd
        @configuration = {}
      end

      # delete empty configuration sets so that when we merge the defaults are loaded in correctly:
      @configuration.delete_if{ |configuration_set, values| values.nil? }

      @configuration = RecursiveOpenStruct.new(defaults.deep_merge(@configuration))
    end

    def create_build_files_directory?
      @configuration.copy_build_files.marshal_dump.values.detect{|v| v}
    end

    def locations
      unless @locations
        expanded_locations = {'root' => Pathname.new(@root_directory)}
        @configuration.locations.marshal_dump.each do |location_type, location|
          expanded_locations[location_type] = Pathname.new(expand_path(location))
        end

        @locations = RecursiveOpenStruct.new(expanded_locations)
      end

      @locations
    end

    def xcode
      unless @xcode
        xcode_settings = @configuration.xcode.marshal_dump
        unless xcode_settings[:build_settings].empty?
          xcode_settings[:build_settings] = ["// Settings from .frankrc xcode.build_settings:",
                                             xcode_settings[:build_settings].gsub(/[\r\n]+$/, ''), 
                                             "// End of .frankrc xcode.build_settings\n"].join "\n"
        end
        xcode_settings[:project] = expand_path(xcode_settings[:project]) if xcode_settings[:project]
        xcode_settings[:workspace] = expand_path(xcode_settings[:workspace]) if xcode_settings[:workspace]

        @xcode = RecursiveOpenStruct.new(xcode_settings)
      end

      @xcode
    end

    def method_missing(name, *args, &block)
      @configuration.send(name, *args, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      @configuration.respond_to?(method_name, include_private)
    end

  private
    def expand_path(path)
      File.expand_path(path, @root_directory)
    end

    def find_frankrc
      all_directories = [Dir.pwd]

      until all_directories[-1] == all_directories[-2]
        all_directories << File.dirname(all_directories.last)
      end

      all_directories.map{ |p| File.join(p, '.frankrc') }.find{ |f| File.exists?(f) }
    end
  end
end