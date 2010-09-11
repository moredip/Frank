require 'uri'
require 'cgi'
require 'net/http'

class IPhoneSim
  attr_accessor :iphonesim_path

  def self.for_ipad_app( app_path )
    self.new( app_path, "3.2", "ipad" )
  end

  def initialize( app_path, sdk, family )
    @iphonesim_path = "iphonesim"
    @app_path = File.expand_path( app_path )
    @sdk = sdk
    @family = family
  end

  def launch
    if iphonesim_server_uri 
      launch_via_http
    else
      launch_via_command
    end
  end

  def relaunch
    launch
  end


  def launch_via_command
    fork do
      system( %Q|"#{@iphonesim_path}" launch "#{@app_path}" #{@sdk} #{@family}| )
    end
  end

  def launch_via_http
    full_request_uri = iphonesim_server_uri.dup
    full_request_uri.query = "app_path=" + CGI.escape( @app_path )
    puts "requesting #{full_request_uri}"
    response = Net::HTTP.get( full_request_uri )
    puts "iphonesim server reponded with:\n#{response}"
  end

  def iphonesim_server_uri
    return URI.parse( @iphonesim_path )
  rescue URI::InvalidURIError
    return nil
  end

end
