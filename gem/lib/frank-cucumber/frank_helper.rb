require 'json'
require 'frank-cucumber/gateway'
require 'frank-cucumber/host_scripting'
require 'frank-cucumber/wait_helper'
require 'frank-cucumber/keyboard_helper'
require 'frank-cucumber/scroll_helper'
require 'frank-cucumber/gesture_helper'
require 'frank-cucumber/location_helper'
require 'frank-cucumber/bonjour'
require 'frank-cucumber/rect.rb'

module Frank module Cucumber

  # FrankHelper provides a core set of helper functions for use when interacting with Frank.
  #
  # == Most helpful methods
  # * {#touch}
  # * {#wait_for_element_to_exist}
  # * {#wait_for_element_to_exist_and_then_touch_it}
  # * {#wait_for_nothing_to_be_animating}
  # * {#app_exec}
  #
  # == Configuring the Frank driver
  # There are some class-level facilities which configure how all Frank interactions work. For example you can specify which selector engine to use
  # with {FrankHelper.selector_engine}. You can specify the base url which the native app's Frank server is listening on with {FrankHelper.server_base_url}.
  #
  # Two common use cases are covered more conveniently with {FrankHelper.use_shelley_from_now_on} and {FrankHelper.test_on_physical_device_via_bonjour}.
module FrankHelper
  include WaitHelper
  include KeyboardHelper
  include ScrollHelper
  include GestureHelper
  include HostScripting
  include LocationHelper

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

  # Get the correct quote for the selector
  def get_selector_quote(selector)
    if selector.index("'") == nil
      return "'"
    else
      return '"'
    end

  # Specify ip address to run on
  def test_on_physical_device_with_ip(ip_address)
      @server_base_url = ip_address
      raise 'IP Address is incorrect' unless @server_base_url.match(%r{\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b})
      puts "Running on Frank server #{@server_base_url}"
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
    touch_successes
  end

  # Fill in text in a text field.
  #
  # @param [String] the placeholder text for the desired text field
  # @param [Hash{Symbol => String}] a hash with a :with key and a string of text to fill in
  # @raise an exception if the :with key DSL syntax is missing
  # @raise an exception if a text field with the given placeholder text could not be found
  def fill_in( placeholder_field_name, options={} )
    raise "Must pass a hash containing the key :with" unless (options.is_a?(Hash) && options.has_key?(:with))
    text_to_type = options[:with]

    quote = get_selector_quote(placeholder_field_name)
    text_fields_modified = frankly_map( "textField placeholder:#{quote}#{placeholder_field_name}#{quote}", "setText:", text_to_type )
    raise "could not find text fields with placeholder #{quote}#{placeholder_field_name}#{quote}" if text_fields_modified.empty?
    #TODO raise warning if text_fields_modified.count > 1
  end

  # Indicate whether there are any views in the current view heirarchy which match the specified selector.
  # @param [String] selector a view selector.
  # @return [Boolean]
  # @see #check_element_exists
  def element_exists( selector )
    matches = frankly_map( selector, 'FEX_accessibilityLabel' )
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

  def check_element_exists_and_is_visible( selector )
    element_is_not_hidden( selector ).should be_true
  end

  # Assert whether there are no views in the current view heirarchy which match the specified selector.
  # @param [String] selector a view selector.
  # @raise an rspec exception if the assertion fails
  # @see #element_exists, #check_element_exists
  def check_element_does_not_exist( selector )
    element_exists( selector ).should be_false
  end

  def check_element_does_not_exist_or_is_not_visible( selector )
    element_is_not_hidden( selector ).should be_false
  end

  # Indicate whether there are any views in the current view heirarchy which contain the specified accessibility label.
  # @param [String] expected_mark the expected accessibility label
  # @return [Boolean]
  # @see #check_view_with_mark_exists
  def view_with_mark_exists(expected_mark)
    quote = get_selector_quote(expected_mark)
    element_exists( "view marked:#{quote}#{expected_mark}#{quote}" )
  end

  # Assert whether there are any views in the current view heirarchy which contain the specified accessibility label.
  # @param [String] expected_mark the expected accessibility label
  # @raise an rspec exception if the assertion fails
  # @see #view_with_mark_exists
  def check_view_with_mark_exists(expected_mark)
    quote = get_selector_quote(expected_mark)
    check_element_exists( "view marked:#{quote}#{expected_mark}#{quote}" )
  end

  # Assert whether there are no views in the current view heirarchy which contain the specified accessibility label.
  # @param [String] expected_mark the expected accessibility label
  # @raise an rspec exception if the assertion fails
  # @see #view_with_mark_exists, #check_view_with_mark_exists
  def check_view_with_mark_does_not_exist(expected_mark)
    quote = get_selector_quote(expected_mark)
    check_element_does_not_exist( "view marked:#{quote}#{expected_mark}#{quote}" )
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


  # Checks that the specified selector matches at least one view, and that at least one of the matched
  # views has an isHidden property set to false
  #
  # a better name for this method would be element_exists_and_is_not_hidden
  def element_is_not_hidden(selector)
     matches = frankly_map( selector, 'FEX_isVisible' )
     matches.delete(false)
     !matches.empty?
  end

  def accessibility_frame(selector)
    frames = frankly_map( selector, 'FEX_accessibilityFrame' )
    raise "the supplied selector [#{selector}] did not match any views" if frames.empty?
    raise "the supplied selector [#{selector}] matched more than one views (#{frames.count} views matched)" if frames.count > 1
    Rect.from_api_repr( frames.first )
  end

  def drag_with_initial_delay(args)
    from, to = args.values_at(:from,:to)
    raise ArgumentError.new('must specify a :from parameter') if from.nil?
    raise ArgumentError.new('must specify a :to parameter') if to.nil?

    dest_frame = accessibility_frame(to)

    if is_mac
      from_frame = accessibility_frame(from)

      frankly_map( from, 'FEX_mouseDownX:y:', from_frame.center.x, from_frame.center.y )

      sleep 0.3

      frankly_map( from, 'FEX_dragToX:y:', dest_frame.center.x, dest_frame.center.y )

      sleep 0.3

      frankly_map( from, 'FEX_mouseUpX:y:', dest_frame.center.x, dest_frame.center.y )

    else

      frankly_map( from, 'FEX_dragWithInitialDelayToX:y:', dest_frame.center.x, dest_frame.center.y )

    end

  end


  # Ask Frank to invoke the specified method on the app delegate of the iOS application under automation.
  # @param method_sig [String] the method signature
  # @param method_args the method arguments
  #
  # @example
  #   # the same as calling
  #   # [[[UIApplication sharedApplication] appDelegate] setServiceBaseUrl:@"http://example.com/my_api" withPort:8080]
  #   # from your native app
  #   app_exec( "setServiceBaseUrl:withPort:", "http://example.com/my_api", 8080 )
  #
  #
  def app_exec(method_sig, *method_args)
    operation_map = Gateway.build_operation_map(method_sig.to_s, method_args)

    res = frank_server.send_post(
      'app_exec',
      :operation => operation_map
    )

    return Gateway.evaluate_frankly_response( res, "app_exec #{method_sig}" )
  end

  # Ask Frank to execute an arbitrary Objective-C method on each view which matches the specified selector.
  #
  # @return [Array] an array with an element for each view matched by the selector, each element in the array gives the return value from invoking the specified method on that view.
  def frankly_map( selector, method_name, *method_args )
    operation_map = Gateway.build_operation_map(method_name.to_s, method_args)
    res = frank_server.send_post(
      'map',
      :query => selector,
      :operation => operation_map,
      :selector_engine => selector_engine
    )

    return Gateway.evaluate_frankly_response( res, "frankly_map #{selector} #{method_name}" )
  end

  # print a JSON-formatted dump of the current view heirarchy to stdout
  def frankly_dump
    res = frank_server.send_get( 'dump' )
    puts JSON.pretty_generate(JSON.parse(res)) rescue puts res #dumping a super-deep DOM causes errors
  end

  # grab a screenshot of the application under automation and save it to the specified file.
  #
  # @param filename [String] where to save the screenshot image file
  # @param subframe describes which section of the screen to grab. If unspecified then the entire screen will be captured. #TODO document what format this parameter takes.
  # @param allwindows [Boolean] If true then all UIWindows in the current UIScreen will be included in the screenshot. If false then only the main window will be captured.
  def frankly_screenshot(filename, subframe=nil, allwindows=true)
    path = 'screenshot'
    path += '/allwindows' if allwindows
    path += "/frame/" + URI.escape(subframe) if (subframe != nil)

    data = frank_server.send_get( path )

    open(filename, "wb") do |file|
      file.write(data)
    end
  end

  # @return [Boolean] true if the device running the application currently in a portrait orientation
  # @note wil return false if the device is in a flat or unknown orientation. Sometimes the iOS simulator will report this state when first launched.
  def frankly_oriented_portrait?
    'portrait' == frankly_current_orientation
  end

  # @return [Boolean] true if the device running the application currently in a landscape orientation
  # @note wil return false if the device is in a flat or unknown orientation. Sometimes the iOS simulator will report this state when first launched.
  def frankly_oriented_landscape?
    'landscape' == frankly_current_orientation
  end

  # @return [String] the orientation of the device running the application under automation.
  # @note this is a low-level API. In most cases you should use {frankly_oriented_portrait} or {frankly_oriented_landscape} instead.
  def frankly_current_orientation
    res = frank_server.send_get( 'orientation' )
    orientation = JSON.parse( res )['orientation']
    puts "orientation reported as '#{orientation}'" if $DEBUG
    orientation
  end


  # set the device orientation
  # @param orientation can be 'landscape','landscape_left','landscape_right','portrait', or 'portrait_upside_down'
  def frankly_set_orientation(orientation)
    orientation = orientation.to_s
    orientation = 'landscape_left' if orientation == 'landscape'
    res = frank_server.send_post( 'orientation',  orientation )
    return Gateway.evaluate_frankly_response( res, "set_orientation #{orientation}" )
  end

  # @return [Boolean] Does the device running the application have accessibility enabled.
  # If accessibility is not enabled then a lot of Frank functionality will not work.
  def frankly_is_accessibility_enabled
    res = frank_server.send_get( 'accessibility_check' )
    JSON.parse( res )['accessibility_enabled'] == 'true'
  end

  # wait for the application under automation to be ready to receive automation commands.
  #
  # Has some basic heuristics to cope with cases where the Frank server is intermittently available when first launching.
  #
  # @raise [Timeout::TimeoutError] if nothing is ready within 20 seconds
  # @raise generic error if the device hosting the application does not appear to have accessibility enabled.
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

  # @return [String] the name of the device currently running the application
  # @note this is a low-level API. In most cases you should use {is_iphone}, {is_ipad} or {is_mac} instead.
  def frankly_device_name
    res = frank_server.send_get( 'device' )
    device = JSON.parse( res )['device']
    puts "device reported as '#{device}'" if $DEBUG
    device
  end

  # @return [Boolean] is the device running the application an iPhone.
  def is_iphone
    return frankly_device_name == "iphone"
  end

  # @return [Boolean] is the device running the application an iPhone.
  def is_ipad
    return frankly_device_name == "ipad"
  end

  # @return [Boolean] is the device running the application a Mac.
  def is_mac
    return frankly_device_name == "mac"
  end

  # Check whether Frank is able to communicate with the application under automation
  def frankly_ping
    frank_server.ping
  end

  #@api private
  #@return [Frank::Cucumber::Gateway] a gateway for sending Frank commands to the application under automation
  def frank_server
    @_frank_server ||= Frank::Cucumber::Gateway.new( base_server_url )
  end

end


end end
