require 'json'
require 'frank-cucumber/gateway'
require 'frank-cucumber/host_scripting'
require 'frank-cucumber/wait_helper'
require 'frank-cucumber/keyboard_helper'
require 'frank-cucumber/bonjour'

module Frank module Cucumber

  # FrankHelper provides a core set of helper functions for use when interacting with Frank.
  #
  # == Configuring the Frank driver
  # There are some class-level facilities which configure how all Frank interactions work. For example you can specify which selector engine to use 
  # with {FrankHelper.selector_engine}. You can specify the base url which the native app's Frank server is listening on with {FrankHelper.server_base_url}.
  #
  # Two common use cases are covered more conveniently with {FrankHelper.use_shelley_from_now_on} and {FrankHelper.test_on_physical_device_via_bonjour}.
module FrankHelper 
  include WaitHelper
  include KeyboardHelper
  include HostScripting

  # @!attribute [rw] selector_engine
  class << self
    # @return [String] the selector engine we tell Frank to use when interpreting view selectors. 
    attr_accessor :selector_engine
    # @return [String] the base url which the Frank server is running on. All Frank commands will be sent to that server.
    attr_accessor :server_base_url

    # After calling this method all subsequent commands will ask Frank to use the Shelley selector engine to interpret view selectors.
    def use_shelley_from_now_on
      @selector_engine = 'shelley_compat'
    end

    # Use Bonjour to search for a running Frank server. The server found will be the recipient for all subsequent Frank commands.
    # @raise a generic exception if no Frank server could be found via Bonjour
    def test_on_physical_device_via_bonjour
      @server_base_url = Bonjour.new.lookup_frank_base_uri
      raise 'could not detect running Frank server' unless @server_base_url
    end
  end

  #@api private
  #@return [:String] convient shorthand for {Frank::Cucumber::FrankHelper.selector_engine}, defaulting to 'uiquery'
  def selector_engine
    Frank::Cucumber::FrankHelper.selector_engine || 'uiquery' # default to UIQuery for backwards compatibility
  end

  #@api private
  #@return [:String] convient shorthand for {Frank::Cucumber::FrankHelper.server_base_url}
  def base_server_url
    Frank::Cucumber::FrankHelper.server_base_url
  end
  
  # Ask Frank to touch all views matching the specified selector. There may be views in the view heirarchy which match the selector but
  # which Frank cannot or will not touch - for example views which are outside the current viewport. You can discover which of the matching
  # views were actually touched by inspecting the Array which is returned.
  #
  # @param [String] selector a view selector.
  # @return [Array<Boolean>] an array indicating for each view which matched the selector whether it was touched or not.
  # @raise an expection if no views matched the selector
  # @raise an expection if no views which matched the selector could be touched
  def touch( selector )
    touch_successes = frankly_map( selector, 'touch' )
    raise "could not find anything matching [#{selector}] to touch" if touch_successes.empty?
    raise "some views could not be touched (probably because they are not within the current viewport)" if touch_successes.include?(false)
  end
  
  # Indicate whether there are any views in the current view heirarchy which match the specified selector.
  # @param [String] selector a view selector.
  # @return [Boolean]
  # @see #check_element_exists
  def element_exists( selector )
    matches = frankly_map( selector, 'accessibilityLabel' )
    # TODO: raise warning if matches.count > 1
    !matches.empty?
  end

  # Assert whether there are any views in the current view heirarchy which match the specified selector.
  # @param [String] selector a view selector.
  # @raise an rspec exception if the assertion fails
  # @see #element_exists, #check_element_does_not_exist
  def check_element_exists( selector )
    element_exists( selector ).should be_true
  end

  # Assert whether there are no views in the current view heirarchy which match the specified selector.
  # @param [String] selector a view selector.
  # @raise an rspec exception if the assertion fails
  # @see #element_exists, #check_element_exists
  def check_element_does_not_exist( selector )
    element_exists( selector ).should be_false
  end

  # Indicate whether there are any views in the current view heirarchy which contain the specified accessibility label.
  # @param [String] expected_mark the expected accessibility label
  # @return [Boolean]
  # @see #check_view_with_mark_exists
  def view_with_mark_exists(expected_mark)
    element_exists( "view marked:'#{expected_mark}'" )
  end

  # Assert whether there are any views in the current view heirarchy which contain the specified accessibility label.
  # @param [String] expected_mark the expected accessibility label
  # @raise an rspec exception if the assertion fails
  # @see #view_with_mark_exists
  def check_view_with_mark_exists(expected_mark)
    check_element_exists( "view marked:'#{expected_mark}'" )
  end

  # Assert whether there are no views in the current view heirarchy which contain the specified accessibility label.
  # @param [String] expected_mark the expected accessibility label
  # @raise an rspec exception if the assertion fails
  # @see #view_with_mark_exists, #check_view_with_mark_exists
  def check_view_with_mark_does_not_exist(expected_mark)
    check_element_does_not_exist( "view marked:'#{expected_mark}'" )
  end


  # Waits for any of the specified selectors to match a view. 
  #
  # Checks each selector in turn within a {http://sauceio.com/index.php/2011/04/how-to-lose-races-and-win-at-selenium/ spin assert} loop and yields the first one which is found to exist in the view heirarchy. 
  # Raises an exception if no views could be found to match any of the provided selectors within {WaitHelper::TIMEOUT} seconds.
  #
  # @see WaitHelper#wait_until
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

  # Waits for the specified selector to not match any views.
  #
  # Uses {WaitHelper#wait_until} to check for any matching views within a {http://sauceio.com/index.php/2011/04/how-to-lose-races-and-win-at-selenium/ spin assert} loop. 
  # Returns as soon as no views match the specified selector.
  # Raises an exception if there continued to be at least one view which matched the selector by the time {WaitHelper::TIMEOUT} seconds passed.
  #
  # @see check_element_does_not_exist
  # @see wait_for_element_to_not_exist
  def wait_for_element_to_not_exist(selector)
    wait_until(:message => "Waited for element #{selector} to not exist") do
      !element_exists(selector)
    end
  end

  # Waits for a view to exist and then send a touch command to that view. 
  #
  # @param selectors takes one or more selectors to use to search for a view. The first selector which is found to matches a view is the selector
  # which is then used to send a touch command.
  #
  # Raises an exception if no views could be found to match any of the provided selectors within {WaitHelper::TIMEOUT} seconds.
  def wait_for_element_to_exist_and_then_touch_it(*selectors)
    wait_for_element_to_exist(*selectors) do |sel| 
      touch(sel)
    end
  end

  # Waits for there to be no views which report an isAnimated property of true.
  #
  # @param timeout [Number] number of seconds to wait for nothing to be animating before timeout out. Defaults to {WaitHelper::TIMEOUT}
  #
  # Raises an exception if there were still views animating after {timeout} seconds.
  def wait_for_nothing_to_be_animating( timeout = false )
    wait_until :timeout => timeout do
      !element_exists('view isAnimating')
    end
  end


  # a better name would be element_exists_and_is_not_hidden
  def element_is_not_hidden(selector)
     matches = frankly_map( selector, 'isHidden' )
     matches.delete(true)
     !matches.empty?
  end

  def app_exec(method_name, *method_args)
    operation_map = Gateway.build_operation_map(method_name.to_s, method_args)
    
    res = frank_server.send_post( 
      'app_exec', 
      :operation => operation_map 
    )

    return Gateway.evaluate_frankly_response( res, "app_exec #{method_name}" )
  end

  def frankly_map( query, method_name, *method_args )
    operation_map = Gateway.build_operation_map(method_name.to_s, method_args)

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
    @_frank_server ||= Frank::Cucumber::Gateway.new( base_server_url )
  end
 
end


end end
