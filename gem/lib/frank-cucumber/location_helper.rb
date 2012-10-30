module Frank
  module Cucumber
    module LocationHelper
      # Ask Frank to set the location.
      #
      # @example
      #   # Set the location to Stockholm
      #   set_location(:latitude => 59.338887, :longitude => 18.058425)
      #
      def set_location(options = {})
        res = frank_server.send_post( 
          'location',
          :latitude => options[:latitude],
          :longitude => options[:longitude]
        )
        Frank::Cucumber::Gateway.evaluate_frankly_response( res, "setting the location to #{options[:latitude]}, #{options[:longitude]}" )
      end
    end
  end
end
