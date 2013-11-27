require 'frank-cucumber/frank_helper'

module Frank module Cucumber

module FrankMacHelper

  # Performs a click at the center of the selected object.
  #
  # This method creates CGEvents to move and click the mouse. Before calling this method,
  # you should make sure that the element that you want to click is frontmost by calling
  # bring_to_front.
  #
  # This method is designed to act on a single object, so do not pass a selector that will
  # return multiple objects.
  def click ( selector )
    frame = accessibility_frame(selector)
    frankly_map( selector, 'FEX_mouseDownX:y:', frame.center.x, frame.center.y )
    frankly_map( selector, 'FEX_mouseUpX:y:', frame.center.x, frame.center.y )
  end

  # Performs a double-click at the center of the selected object.
  #
  # This method creates CGEvents to move and click the mouse. Before calling this method,
  # you should make sure that the element that you want to click is frontmost by calling
  # bring_to_front.
  #
  # This method is designed to act on a single object, so do not pass a selector that will
  # return multiple objects.
  def double_click ( selector )
    click(selector)
    click(selector)
  end

  #@api private
  def perform_action_on_selector( action, selector )
    touch_successes = frankly_map( selector, action )
    raise "could not find anything matching [#{selector}] which supports that action" if touch_successes == nil or touch_successes.empty?
    raise "some objects do not support that action" if touch_successes.include?(false)
  end

  # Simulates the effect of clicking on the selected objects without actually moving the
  # mouse or clicking.
  #
  # If the object supports the NSAccessibilityPressAction, that action is performed.
  # Otherwise, if the object is a table cell or row, that row is selected,
  # Otherwise, if the object is an NSView, it is made the first responder, if possible
  # Otherwise, if the object is a menu item, it opens its submenu if it has one, or
  # performs it's action if not.
  def simulate_click( selector )
    perform_action_on_selector( 'FEX_simulateClick', selector )
  end

  # Brings the selected application or window to the front.
  def bring_to_front( selector )
    perform_action_on_selector( 'FEX_raise', selector )
  end

  # Cancels the current action, such as editing a text field.
  def cancel( selector )
    perform_action_on_selector( 'FEX_cancel', selector )
  end

  # Finishes the current action, such as editing a text field.
  def confirm( selector )
    perform_action_on_selector( 'FEX_confirm', selector )
  end

  # Decrements the value of NSSliders, NSSteppers, and similar controls
  def decrement_value( selector )
    perform_action_on_selector( 'FEX_decrement', selector )
  end

  # Deletes the user-inputted value
  def delete_value( selector )
    perform_action_on_selector( 'FEX_delete', selector )
  end

  # Increments the value of NSSliders, NSSteppers, and similar controls
  def increment_value( selector )
    perform_action_on_selector( 'FEX_increment', selector )
  end

  # Selects a menu item. This action is considered "outdated" by the Accessibility API, so
  # don't use it without a good reason.
  def pick( selector )
    perform_action_on_selector( 'FEX_pick', selector )
  end

  # Shows the contextual menu associated with the selector. This is the menu that would
  # appear if the user right-clicked the selector, or, in some cases, held down the left
  # mouse button on the selector.
  def show_menu( selector )
    perform_action_on_selector( 'FEX_showMenu', selector )
  end

  # Expands the row the selector belongs to in an NSOutlineView. Do not expand more than
  # one row at a time.
  def expand_row( selector )
    perform_action_on_selector( 'FEX_expand', selector )
  end

  # Collapses the row the selector belongs to in an NSOutlineView. Do not expand more than
  # one row at a time.
  def collapse_row( selector )
    perform_action_on_selector( 'FEX_collapse', selector )
  end

  # @return [Boolean] whether the rows the selectors belong to in an NSOutlineView are all
  # expanded
  def row_is_expanded( selector )
    successes = frankly_map( selector, "FEX_isExpanded" )
    return false if successes == nil or successes.empty?
    return !successes.include?(false)
  end

end

end

end
