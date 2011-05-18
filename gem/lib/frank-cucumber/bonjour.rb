require 'rubygems'
require 'dnssd'

FRANK_SERVICE_NAME = 'Frank UISpec server'
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

def get_franks_address
  DNSSD.browse! '_http._tcp.' do |reply|
    debug 'got a reply'
    if reply.name == FRANK_SERVICE_NAME 
      address = found_a_frank(reply)
      if address
        debug "OK WE HAVE AN ADDRESS, START RUNNING TESTS"
        return address
      end
    end
  end
end



address = nil
begin
  Timeout::timeout(LOOKUP_TIMEOUT){ address = get_franks_address }
rescue Timeout::Error
  puts "could not find frank within #{LOOKUP_TIMEOUT} seconds"
end

if address
  puts 'found frank!', address.to_s
else
  puts 'no frank to be found!'
end
