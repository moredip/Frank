require 'timeout'

module Frank
module Cucumber

# This module contains a single method called wait_until which implements the {http://sauceio.com/index.php/2011/04/how-to-lose-races-and-win-at-selenium/ Spin Assert} pattern.
#
# When we mix this module into another class or module (such as {FrankHelper}) then that wait_until method will be available inside 
# that class or module. Because we call module_function at the end of the module this method is also available as a static method on the module. 
# That means you can also call {Frank::Cucumber::WaitHelper.wait_until} from anywhere in your code.
#
module WaitHelper
  # Default option for how long (in seconds) to keep checking before timing out the entire wait
  TIMEOUT = (ENV['WAIT_TIMEOUT'] || 240).to_i
  # How long to pause (in seconds) inbetween each spin through the assertion block
  POLL_SLEEP = 0.1

  # Repeatedly evaluate the passed in block until either it returns true or a timeout expires. Between 
  # evaluations there is a pause of {POLL_SLEEP} seconds.
  #
  # wait_until takes the following options:
  #  :timeout - How long in seconds to keep spinning before timing out of the entire operation. Defaults to TIMEOUT
  #  :message - What to raise in the event of a timeout. Defaults to an empty StandardError
  # 
  # @yield the assertion to wait for
  # @yieldreturn whether the assertion was met
  #
  #
  # Here's an example where we will keep calling the reticulate_splines method until either it returns a result
  # greater than 0 or 20 seconds elapses. In the timeout case an exception will be raised 
  # saying "timed out waiting for splines to reticulate":
  #
  #   wait_until( :timeout => 20, :message => 'timed out waiting for splines to reticulate' ) do
  #     num_splines_reticulated = reticulate_splines(1,2,3)
  #     num_splines_reticulated > 0
  #   end
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
