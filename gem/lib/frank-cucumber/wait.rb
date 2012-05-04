require 'timeout'

module Frank
module Cucumber

module WaitHelper
  TIMEOUT = ENV['WAIT_TIMEOUT'].to_i || 240
  POLL_SLEEP = 0.1 #seconds

  def wait_until(opts = {})
    timeout = opts[:timeout] || TIMEOUT
    message = opts[:message]

    begin
      Timeout::timeout(timeout) do
        until yield
          sleep POLL_SLEEP
        end
      end
    rescue Timeout::Error => e
      raise message if message
      raise
    end
  end

  module_function :wait_until
end

end
end
