require 'erb'

module Frank
  module Plugins
    class Plugin

      attr_accessor :name, :xcconfig

      def initialize(name,xcconfig)
        self.name = name
        self.xcconfig = xcconfig
      end

      def self.from_plugin_directory(path)
        xcconfig = Dir[File.join(path, '*.xcconfig')].first
        Plugin.new(File.basename(path), File.basename(xcconfig))
      end

      def self.generate_xcconfig_from(plugins)
        _template = ERB.new(File.read(frank_xcconfig_path))

        _template.result(binding)
      end

      def self.frank_xcconfig_path
        File.expand_path(File.join(File.dirname(__FILE__), '..', 'frank.xcconfig.erb'))
      end

    end
  end
end