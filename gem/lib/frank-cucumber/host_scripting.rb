require 'frank-cucumber/frank_localize'

module Frank module Cucumber

module HostScripting
  
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

  def set_custom_location( latitude, longitude )
    %x{osascript<<APPLESCRIPT
      activate application "iPhone Simulator"
      tell application "System Events"
        tell process "#{Localize.t(:iphone_simulator)}"
          tell menu bar 1
            tell menu bar item "#{Localize.t(:debug)}"
              tell menu "#{Localize.t(:debug)}"
                tell menu item "#{Localize.t(:location)}"
                  tell menu "#{Localize.t(:location)}"
                    click menu item "#{Localize.t(:custom_location)}"
                  end tell
                end tell
              end tell
            end tell
          end tell
          tell window 1
            tell text field 1
              set value to "#{latitude}"
            end tell
            tell text field 2
              set value to "#{longitude}"
            end tell
            click button "OK"
          end tell
        end tell
      end tell
    APPLESCRIPT}  
  end
end 

end end
