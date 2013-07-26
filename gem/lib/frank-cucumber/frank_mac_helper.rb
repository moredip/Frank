require 'frank-cucumber/frank_helper'

module Frank module Cucumber

module FrankHelper

  def click ( selector )
    frame = accessibility_frame(selector)
    frankly_map( selector, 'FEX_mouseDownX:y:', frame.center.x, frame.center.y )
    frankly_map( selector, 'FEX_mouseUpX:y:', frame.center.x, frame.center.y )
  end

  def double_click ( selector )
    click(selector)
    click(selector)
  end

  def perform_action_on_selector( action, selector )
    touch_successes = frankly_map( selector, action )
    raise "could not find anything matching [#{selector}] which supports that action" if touch_successes == nil or touch_successes.empty?
    raise "some objects do not support that action" if touch_successes.include?(false)
  end

  def simulate_click( selector )
    perform_action_on_selector( 'FEX_simulateClick', selector )
  end

  def bring_to_front( selector )
    perform_action_on_selector( 'FEX_raise', selector )
  end

  def cancel( selector )
    perform_action_on_selector( 'FEX_cancel', selector )
  end

  def confirm( selector )
    perform_action_on_selector( 'FEX_confirm', selector )
  end

  def decrement_value( selector )
    perform_action_on_selector( 'FEX_decrement', selector )
  end

  def delete_value( selector )
    perform_action_on_selector( 'FEX_delete', selector )
  end

  def increment_value( selector )
    perform_action_on_selector( 'FEX_increment', selector )
  end

  def pick( selector )
    perform_action_on_selector( 'FEX_pick', selector )
  end

  def show_menu( selector )
    perform_action_on_selector( 'FEX_showMenu', selector )
  end

end

end

end
