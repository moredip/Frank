require 'erb'

module Frank
  module Plugins
    class Plugin

      attr_accessor :plugin_dir, :name, :exclude_dependencies

      def initialize(plugin_dir, name)
        self.plugin_dir= plugin_dir
        self.name = name
      end

      def dependency(lib,linker_flag="-l#{lib}")
        return linker_flag unless exclude_dependencies.include?(lib)
        ''
      end

      def write_xcconfig(exclude_dependencies)
          self.exclude_dependencies= exclude_dependencies

          _xcconfig_erb = File.join(plugin_dir,"#{xcconfig}.erb")

          unless File.exist?(_xcconfig_erb)
            raise "Invalid plugin #{name} at #{File.join(plugin_dir)}.\nDoesn't have an erb file: #{_xcconfig_erb}"
          end


          _template = ERB.new(File.read(_xcconfig_erb))
          result = _template.result(binding)
          output_path = File.join(plugin_dir, xcconfig)
          File.open(output_path,'w') {|f| f.write(result)}
          output_path
      end

      def xcconfig
        "#{name}.xcconfig"
      end

      def self.from_plugin_directory(path)
        plugin_name = File.basename(path)
        Plugin.new(path, plugin_name)
      end

      def self.generate_core_xcconfig(plugins)
        _template = ERB.new(File.read(core_xcconfig_path))

        _template.result(binding)
      end

      def self.core_xcconfig_path
        File.expand_path(File.join(File.dirname(__FILE__), '..', 'frank.xcconfig.erb'))
      end

    end
  end
end