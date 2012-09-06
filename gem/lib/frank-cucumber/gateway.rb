require 'net/http'
require 'uri'

module Frank module Cucumber

class Gateway
  DEFAULT_BASE_URL = "http://localhost:37265/"

  def initialize( base_url = nil )
    @base_url = URI.parse( (base_url || DEFAULT_BASE_URL).to_s )
  end

  def ping
    send_get('')
    return true
  rescue FrankNetworkError
    return false
  end

  class << self
    def build_operation_map( method_sig, method_args )
      num_args_according_to_method_sig = method_sig.count(':')

      if num_args_according_to_method_sig != method_args.count
        raise <<-EOS
          
          The method you've specified - #{method_sig} - wants #{num_args_according_to_method_sig} arguments, but you've supplied #{method_args.count} arguments.

        EOS
      end

      if num_args_according_to_method_sig > 0 && !method_sig.end_with?(':')
        raise <<-EOS

          The method signature you've specified - #{method_sig} - is invalid. Objective C method signatures which take parameters must end with a :

        EOS
      end

      {
        :method_name => method_sig,
        :arguments => method_args,
      }
    end

    def evaluate_frankly_response( json, req_desc )
      res = JSON.parse( json )
      if res['outcome'] != 'SUCCESS'
        raise "#{req_desc} failed because: #{res['reason']}\n#{res['details']}"
      end

      res['results']
    end
  end

  #taken from Ian Dee's Encumber
  def send_post( verb, command )
    command = command.to_json unless command.is_a? String

    url = frank_url_for( verb )
    req = Net::HTTP::Post.new url.path
    req.body = command

    make_http_request( url, req )
  end

  def send_get( verb )
    url = frank_url_for( verb )
    req = Net::HTTP::Get.new url.path
    make_http_request( url, req )
  end
  
  private

  def frank_url_for( verb )
    url = @base_url.clone
    url.path = '/'+verb
    url
  end

  def make_http_request( url, req )
    http = Net::HTTP.new(url.host, url.port)

    begin
      res = http.start do |sess|
        sess.request req
      end

      res.body
    rescue Errno::ECONNREFUSED
      raise FrankNetworkError 
    rescue EOFError
      raise FrankNetworkError
    end
  end

end


class FrankNetworkError < RuntimeError
  OVERLY_VERBOSE_YET_HELPFUL_ERROR_MESSAGE = <<EOS
  

*********************************************
Oh dear. Your app fell over and can't get up.
*********************************************


We just encountered an error while trying to talk to the Frank server embedded 
within the app under test. This usually means that the app has just crashed, 
either while carrying out the current step or while finishing up the previous 
step.

Here are some things you could do next:

- Take a look at the app's logs to see why it crashed. You can view the logs 
  in Console.app (a search for 'Frankified' will usually find your frankified 
  app's output).

- Launch your frankified app in the XCode debugger and then run this scenario 
  again. You'll get lots of helpful output from XCode. Don't forget to do 
  something to prevent cucumber from automatically re-launching your app when 
  you run the scenario by hand. If you don't prevent the relaunch then you 
  won't still be in the XCode debugger when the crash happens.

  

EOS

  def initialize
    super OVERLY_VERBOSE_YET_HELPFUL_ERROR_MESSAGE
  end
end

end end
