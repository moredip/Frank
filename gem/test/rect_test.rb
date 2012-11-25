require_relative 'test_helper.rb'

require_relative '../lib/frank-cucumber/rect'

module Frank module Cucumber

describe Rect do
  it 'parsing from the api hash representation correctly' do
    api_repr = { "origin" => {"x" => 1.1, "y" => 2.2}, "size" => { "height" => 11.1, "width" => 22.2 } }
    rect = Rect.from_api_repr( api_repr )

    rect.x.must_equal 1.1
    rect.y.must_equal 2.2
    rect.width.must_equal 22.2
    rect.height.must_equal 11.1
  end

  it 'calculates the center correctly' do
    rect = Rect.new( 100, 200, 11, 21 )
    rect.center.x.must_equal 105.5
    rect.center.y.must_equal 210.5
  end
end

end end
