require 'frank-cucumber/frank_helper'
require 'frank-cucumber/frank_mac_helper'
require 'frank-cucumber/launcher'

module Frank
  class Console
    include Frank::Cucumber::FrankHelper
    include Frank::Cucumber::Launcher

    def check_for_running_app
      print 'connecting to app...'
      begin
        Timeout::timeout(5) do
          until frankly_ping
            print '.'
            sleep 0.2
          end
        end
      rescue Timeout::Error
        puts ' failed to connect.'
        return false
      end
      puts ' connected'
      return true
    end
  end
end
