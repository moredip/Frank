require "ostruct"

module Frank module Cucumber

  class Rect
    attr_reader :x, :y, :width, :height

    def self.from_api_repr( hash )
      x,y = hash["origin"]["x"], hash["origin"]["y"]
      width,height = hash["size"]["width"],hash["size"]["height"]
      self.new( x, y, width, height )
    end

    def initialize(x,y,width,height)
      @x,@y,@width,@height = x,y,width,height
    end

    def center
      OpenStruct.new( 
                     :x => @x.to_f + (@width.to_f/2),
                     :y => @y.to_f + (@height.to_f/2)
                    )
    end
  end

end end
