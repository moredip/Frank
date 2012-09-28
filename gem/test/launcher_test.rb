require_relative 'test_helper.rb'

include Frank::Cucumber::Launcher
include Frank::Cucumber::FrankHelper

def wait_for_frank_to_come_up
  # orig FrankHelper::wait_for_frank_to_come_up
  # doing nothing
end

describe "frank cucumber launcher" do
  DUMMY_APP_PATH = '/tmp/dummy_app_path'

  before do
    `mkdir -p #{DUMMY_APP_PATH}`
  end

  describe "when the path is wrong" do
  
    it 'throws exception when no app path is given' do
      assert_raises(RuntimeError) do
        enforce(nil)
      end
    end

    it 'prints suggestions if available' do
        mock_locator = Mock.new
        mock_locator.expect :guess_possible_app_bundles_for_dir, ['suggestion_1'], ['']
        begin
          enforce(nil, mock_locator)
        rescue RuntimeError => e
          e.message.must_match "suggestion_1"
        end
    end

    it "throws exception when app path doesn't exist" do
      assert_raises(RuntimeError) do
        enforce('/foo/bar/baz/not/a/real/path')
      end
    end
  end

  describe "when starting the simulator with the specified params" do

    before do
      @simulator_direct_client = Mock.new 
      @simulator_direct_client.expect :relaunch, nil, [] 
    end
    
    it 'selects iphone mode by default' do
      launch_app(DUMMY_APP_PATH, 'X.Y')
      @version.must_equal 'iphone'
    end

  end

end
