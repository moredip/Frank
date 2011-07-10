require 'frank-cucumber'

APP_BUNDLE_PATH = File.dirname(__FILE__) + "/../../build/Debug-iphonesimulator/EmployeeAdmin.app"

def serialize_point( x, y )
  "{#{x},#{y}}"
end
