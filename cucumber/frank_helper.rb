require 'net/http'
require 'json'

module FrankHelper

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

  def app_exec(method_name, *method_args)
    operation_map = {
      :method_name => method_name,
      :arguments => method_args
    }
    
    before = Time.now
    res = post_to_uispec_server( 'app_exec', :operation => operation_map )
    logger.debug( "MAP applying #{method_name} with args:( #{method_args.inspect} ) to 'Application Delegate' took #{Time.now - before} seconds" )

    res = JSON.parse( res )
    if res['outcome'] != 'SUCCESS'
      raise "app_exec #{method_name} failed because: #{res['reason']}\n#{res['details']}"
    end

    res['results']
  end
  
  
  def frankly_map( query, method_name, *method_args )
    operation_map = {
      :method_name => method_name,
      :arguments => method_args
    }
    res = post_to_uispec_server( 'map', :query => query, :operation => operation_map )
    res = JSON.parse( res )
    if res['outcome'] != 'SUCCESS'
      raise "frankly_map #{query} #{method_name} failed because: #{res['reason']}\n#{res['details']}"
    end

    res['results']
  end

  def frankly_dump
    res = get_to_uispec_server( 'dump' )
    puts JSON.pretty_generate(JSON.parse(res)) rescue puts res #dumping a super-deep DOM causes errors
  end

  def frankly_oriented_portrait?
    'portrait' == frankly_current_orientation
  end

  def frankly_oriented_landscape?
    'landscape' == frankly_current_orientation
  end

  def frankly_current_orientation
    res = get_to_uispec_server( 'orientation' )
    JSON.parse( res )['orientation']
  end

  def wait_for_frank_to_come_up
    num_consec_successes = 0
    num_consec_failures = 0
    Timeout.timeout(60) do
      while num_consec_successes <= 6
        if frankly_ping
          num_consec_failures = 0
          num_consec_successes += 1
          print (num_consec_successes == 1 ) ? "\n" : "\r"
          print "FRANK!".slice(0,num_consec_successes)
        else
          num_consec_successes = 0
          num_consec_failures += 1
          print (num_consec_failures == 1 ) ? "\n" : "\r"
          print "PING FAILED" + "!"*num_consec_failures
        end
        STDOUT.flush
        sleep 0.2
      end
      puts ''
    end
  end

  def frankly_ping
    get_to_uispec_server('')
    return true
  rescue Errno::ECONNREFUSED
    return false
  rescue EOFError
    return false
  end

  #taken from Ian Dee's Encumber
  def post_to_uispec_server( verb, command_hash )
    url = frank_url_for( verb )
    req = Net::HTTP::Post.new url.path
    req.body = command_hash.to_json

    make_http_request( url, req )
  end

  def get_to_uispec_server( verb )
    url = frank_url_for( verb )
    req = Net::HTTP::Get.new url.path
    make_http_request( url, req )
  end

  def frank_url_for( verb )
    url = URI.parse "http://localhost:37265/"
    url.path = '/'+verb
    url
  end

  def make_http_request( url, req )
    http = Net::HTTP.new(url.host, url.port)

    res = http.start do |sess|
      sess.request req
    end

    res.body
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
  
  def launch_app_in_simulator
    %x{osascript<<APPLESCRIPT
application "iPhone Simulator" quit
tell application "Xcode"
	set myprojectdocument to active project document
	set myproject to project of myprojectdocument
	tell myproject
		launch
	end tell
end tell
application "iPhone Simulator" activate
  APPLESCRIPT}
    sleep 5 # TODO: replace this with polling for the frank server
  end

  #Note this needs to have "Enable access for assistive devices"
  #chcked in the Universal Access system preferences
  def simulator_hardware_menu_press( menu_label )
    %x{osascript<<APPLESCRIPT
activate application "iPhone Simulator"
tell application "System Events"
	click menu item "#{menu_label}" of menu "Hardware" of menu bar of process "iPhone Simulator"
end tell
  APPLESCRIPT}  
  end
  
  def press_home_on_simulator
    simulator_hardware_menu_press "Home"
  end
  
  def rotate_simulator_left
    simulator_hardware_menu_press "Rotate Left"
  end

  def rotate_simulator_right
    simulator_hardware_menu_press "Rotate Right"
  end

  def shake_simulator
    simulator_hardware_menu_press "Shake Gesture"
  end
  
  def simulate_memory_warning
    simulator_hardware_menu_press "Simulate Memory Warning"
  end
  
  def toggle_call_status_bar
    simulator_hardware_menu_press "Toggle In-Call Status Bar"
  end
end
