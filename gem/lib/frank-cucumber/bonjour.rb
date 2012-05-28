require 'timeout'
require 'uri'

module Frank module Cucumber
class Bonjour

  FRANK_SERVICE_NAME = 'Frank UISpec server'
  FRANK_PORT = 37265
  LOOKUP_TIMEOUT = 10

  def debug string
    puts string if $DEBUG
  end

  def found_a_frank( reply )
    debug reply.inspect
    unless reply.flags.add?
      debug 'got a non-add reply'
      debug "flags: #{reply.flags.to_a.inspect}"
      return nil
    end

    resolve_service = DNSSD::Service.new
    addr_service = DNSSD::Service.new
    resolve_service.resolve reply do |r|
      debug "#{r.name} on #{r.target}:#{r.port}"

      address = nil
      addr_service.getaddrinfo r.target do |addrinfo|
        address = addrinfo.address
        break
      end

      debug "first address for #{r.target} is #{address}"
      return address
    end
  end

  def browse_for_franks_address
    require 'dnssd'

    DNSSD.browse! '_http._tcp.' do |reply|
      debug 'got a reply'
      if reply.name == FRANK_SERVICE_NAME 
        address = found_a_frank(reply)
        if address
          debug "OK WE HAVE AN ADDRESS: #{address}"
          return address
        end
      end
    end
  end

  def lookup_frank_base_uri
    puts "finding Frank server via Bonjour..."
    address = begin
      Timeout::timeout(LOOKUP_TIMEOUT){ address = browse_for_franks_address }
    rescue Timeout::Error
      puts "could not find Frank within #{LOOKUP_TIMEOUT} seconds"
    end

    if address
      puts "...found Frank via Bonjour: #{address}"
      return URI::HTTP.new( 'http', nil, address, FRANK_PORT, nil, nil, nil, nil, nil )
    else
      puts '...failed to find Frank server via Bonjour'
      return nil
    end
  end

end

end end
