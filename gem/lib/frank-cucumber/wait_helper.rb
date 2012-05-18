require 'timeout'

module Frank
module Cucumber

# What's going on here?!
#
# This module contains a single method called wait_until. When we mix this module into another class or module (such as 
# FrankHelper) then that wait_until method will be available inside that class or module. Because we call module_function
# at the end of the module this method is also available as a static method on the module. That means you can also call 
# Frank::Cucumber::WaitHelper.wait_until from anywhere in your code.
#
#
# wait_until will repeatedly execute the passed in block until either it returns true or a timeout expires. Between 
# executions there is a pause of POLL_SLEEP seconds.
#
# wait_until takes two options, a timeout and a message. 
# The timeout defaults to the WaitHelper::TIMEOUT constant. That constant is based off of a WAIT_TIMEOUT 
# environment variable, otherwise it defaults to 240 seconds.
# If a message is passed in as an option then that message is used when reporting a timeout.
#
#
# Example usage: 
#
# wait_until( :timeout => 20, :message => 'timed out waiting for splines to reticulate' ) do
#   num_splines_reticulated = reticulate_splines(1,2,3)
#   num_splines_reticulated > 0
# end
# 
# Here we will keep calling the reticulate_splines method until either it returns a result
# greater than 0 or 20 seconds elapses. In the timeout case an exception will be raised 
# saying "timed out waiting for splines to reticulate"

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
