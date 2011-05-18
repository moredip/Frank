module Frank
  USING_PHYSICAL_DEVICE = !!ENV['USING_PHYSICAL_DEVICE'] || 
    ( defined?(::USING_PHYSICAL_DEVICE) && !!::USING_PHYSICAL_DEVICE ) ||
    false

  def self.discover_frank_server_base_uri
    if USING_PHYSICAL_DEVICE
      address = Frank::Bonjour.new.lookup_frank_base_uri
      raise 'could not detect running Frank server' unless address
      address
    else
      URI.parse "http://localhost:37265/"
    end
  end
end
