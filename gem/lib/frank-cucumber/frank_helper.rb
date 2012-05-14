require 'json'
require 'frank-cucumber/gateway'
require 'frank-cucumber/frank_localize'
require 'frank-cucumber/wait_helper'

module Frank module Cucumber

module FrankHelper 
  include WaitHelper

  class << self
    # TODO: adding an ivar to the module itself is a big ugyl hack. We need a FrankDriver class, or similar
    attr_accessor :selector_engine
    def use_shelley_from_now_on
      @selector_engine = 'shelley_compat'
    end
  end

  def selector_engine
    Frank::Cucumber::FrankHelper.selector_engine || 'uiquery' # default to UIQuery for backwards compatibility
  end
  
  def touch( uiquery )
    views_touched = frankly_map( uiquery, 'touch' )
    raise "could not find anything matching [#{uiquery}] to touch" if views_touched.empty?
    #TODO raise warning if views_touched.count > 1
  end

  def element_exists( query )
    matches = frankly_map( query, 'accessibilityLabel' )
    # TODO: raise warning if matches.count > 1
    !matches.empty?
  end

  def check_element_exists( query )
    #puts "checking #{query} exists..."
    element_exists( query ).should be_true
  end

  def check_element_does_not_exist( query )
    #puts "checking #{query} does not exist..."
    element_exists( query ).should be_false
  end

  def view_with_mark_exists(expected_mark)
    element_exists( "view marked:'#{expected_mark}'" )
  end

  def check_view_with_mark_exists(expected_mark)
    check_element_exists( "view marked:'#{expected_mark}'" )
  end

  def check_view_with_mark_does_not_exist(expected_mark)
    check_element_does_not_exist( "view marked:'#{expected_mark}'" )
  end


  # Waits for any of the selectors provided to match a view. Returns true
  # as soon as we find a matching view, otherwise keeps testing until timeout.
  # The first selector which matches is passed to a block if it was provided. 
  def wait_for_element_to_exist(*selectors,&block)
    wait_until(:message => "Waited for element matching any of #{selectors.join(', ')} to exist") do
      at_least_one_exists = false
      selectors.each do |selector|
        if element_exists( selector )
          at_least_one_exists = true
          block.call(selector) if block
        end
      end
      at_least_one_exists
    end
  end

  def wait_for_element_to_not_exist(selector)
    wait_until(:message => "Waited for element #{selector} to not exist") do
      !element_exists(selector)
    end
  end

  def wait_for_element_to_exist_and_then_touch_it(*selectors)
    wait_for_element_to_exist(*selectors) do |sel| 
      touch(sel)
    end
  end

  def wait_for_nothing_to_be_animating( timeout = false )
    wait_until :timeout => timeout do
      !element_exists('view isAnimating')
    end
  end


  # a better name would be element_exists_and_is_not_hidden
  def element_is_not_hidden(query)
     matches = frankly_map( query, 'isHidden' )
     matches.delete(true)
     !matches.empty?
  end

  def app_exec(method_name, *method_args)
    operation_map = Gateway.build_operation_map(method_name,method_args)
    
    res = frank_server.send_post( 
      'app_exec', 
      :operation => operation_map 
    )

    return Gateway.evaluate_frankly_response( res, "app_exec #{method_name}" )
  end

  def frankly_map( query, method_name, *method_args )
    operation_map = Gateway.build_operation_map(method_name,method_args)

    res = frank_server.send_post( 
      'map',
      :query => query, 
      :operation => operation_map, 
      :selector_engine => selector_engine
    )

    return Gateway.evaluate_frankly_response( res, "frankly_map #{query} #{method_name}" )
  end

  def frankly_dump
    res = frank_server.send_get( 'dump' )
    puts JSON.pretty_generate(JSON.parse(res)) rescue puts res #dumping a super-deep DOM causes errors
  end

  def frankly_screenshot(filename, subframe=nil, allwindows=true)
    path = 'screenshot'
    path += '/allwindows' if allwindows
    path += "/frame/" + URI.escape(subframe) if (subframe != nil)

    data = frank_server.send_get( path )

    open(filename, "wb") do |file|
      file.write(data)
    end
  end

  def frankly_oriented_portrait?
    'portrait' == frankly_current_orientation
  end

  def frankly_oriented_landscape?
    'landscape' == frankly_current_orientation
  end

  def frankly_current_orientation
    res = frank_server.send_get( 'orientation' )
    orientation = JSON.parse( res )['orientation']
    puts "orientation reported as '#{orientation}'" if $DEBUG
    orientation
  end

  def frankly_is_accessibility_enabled
    res = frank_server.send_get( 'accessibility_check' )
    JSON.parse( res )['accessibility_enabled'] == 'true'
  end

  def wait_for_frank_to_come_up
    num_consec_successes = 0
    num_consec_failures = 0
    Timeout.timeout(20) do
      while num_consec_successes <= 6
        if frankly_ping
          num_consec_failures = 0
          num_consec_successes += 1
        else
          num_consec_successes = 0
          num_consec_failures += 1
          if num_consec_failures >= 5 # don't show small timing errors
            print (num_consec_failures == 5 ) ? "\n" : "\r"
            print "PING FAILED" + "!"*num_consec_failures
          end
        end
        STDOUT.flush
        sleep 0.2
      end

      if num_consec_successes < 6
        print (num_consec_successes == 1 ) ? "\n" : "\r"
        print "FRANK!".slice(0,num_consec_successes)
        STDOUT.flush
        puts ''
      end

      if num_consec_failures >= 5
        puts ''
      end
    end

    unless frankly_is_accessibility_enabled
      raise "ACCESSIBILITY DOES NOT APPEAR TO BE ENABLED ON YOUR SIMULATOR. Hit the home button, go to settings, select Accessibility, and turn the inspector on."
    end
  end
  
  def frankly_ping
    frank_server.ping
  end

  def frank_server
    @_frank_server ||= Frank::Cucumber::Gateway.new
  end
 


  
  def start_recording
    %x{osascript<<APPLESCRIPT
	tell application "QuickTime Player"
	set sr to new screen recording
	  tell sr to start
	end tell
  APPLESCRIPT}
  
  end

  def stop_recording
    %x{osascript<<APPLESCRIPT
	tell application "QuickTime Player"
	  set sr to (document 1)
	  tell sr to stop
	end tell
  APPLESCRIPT}  
  end
  
  def quit_simulator
    %x{osascript<<APPLESCRIPT-
      application "iPhone Simulator" quit
    APPLESCRIPT}
  end

def simulator_reset_data
  %x{osascript<<APPLESCRIPT
activate application "iPhone Simulator"
tell application "System Events"
  click menu item 5 of menu 1 of menu bar item 2 of menu bar 1 of process "#{Localize.t(:iphone_simulator)}"
  delay 0.5
  click button 2 of window 1 of process "#{Localize.t(:iphone_simulator)}"
end tell
  APPLESCRIPT} 
end

  #Note this needs to have "Enable access for assistive devices"
  #chcked in the Universal Access system preferences
  def simulator_hardware_menu_press( menu_label )
    %x{osascript<<APPLESCRIPT
activate application "iPhone Simulator"
tell application "System Events"
	click menu item "#{menu_label}" of menu "#{Localize.t(:hardware)}" of menu bar of process "#{Localize.t(:iphone_simulator)}"
end tell
  APPLESCRIPT}  
  end
  
  def press_home_on_simulator
    simulator_hardware_menu_press Localize.t(:home)
  end
  
  def rotate_simulator_left
    simulator_hardware_menu_press Localize.t(:rotate_left)
  end

  def rotate_simulator_right
    simulator_hardware_menu_press Localize.t(:rotate_right)
  end

  def shake_simulator
    simulator_hardware_menu_press Localize.t(:shake_gesture)
  end
  
  def simulate_memory_warning
    simulator_hardware_menu_press Localize.t(:simulate_memory_warning)
  end
  
  def toggle_call_status_bar
    simulator_hardware_menu_press Localize.t(:toggle_call_status_bar)
  end
  
  def simulate_hardware_keyboard
    simulator_hardware_menu_press Localize.t(:simulate_hardware_keyboard)
  end
end


end end
