require 'i18n'

module Frank
  module Cucumber
    module Localize

      def self.system_locale
        case ENV['LANG']
        when /^fr_/
          :fr
        when /^de_/
          :de
        when /^ru_/
          :ru
        when /^zh_/
          :zh
        when /^ja_/
          :ja
        when /^es_/
          :es
        when /^it_/
          :it
        else
          :en
        end
      end

      def self.load_translations
        if I18n.backend.send(:translations).size == 0
          I18n.locale = self.system_locale
          I18n.load_path = [ File.join(File.dirname(__FILE__), 'localize.yml') ]
          I18n.backend.load_translations
        end
      end

      def self.t(key)
        self.load_translations
        I18n.t(key)
      end

    end
  end
end
