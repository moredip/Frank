require 'frank-cucumber/frank_helper'

module Frank module Cucumber

module FrankHelper

  def simulate_click( selector )
    touch_successes = frankly_map( selector, 'FEX_simulateClick' )
    raise "could not find anything matching [#{selector}] to press" if touch_successes == nil or touch_successes.empty?
    raise "some objects do not support the press action" if touch_successes.include?(false)
  end

  def bring_to_front( selector )
    touch_successes = frankly_map( selector, 'FEX_raise' )
    raise "could not find anything matching [#{selector}] to bring to the front" if touch_successes == nil or touch_successes.empty?
    raise "some objects do not support the bring to front action" if touch_successes.include?(false)
  end

end

end

end
