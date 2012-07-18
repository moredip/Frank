require_relative 'test_helper.rb'

class HelperForTesting
  include Frank::Cucumber::KeyboardHelper


  def mock_frank_server
    RR.mock(@mock_frank_server = Object.new)
  end

  private
  def frank_server
    @mock_frank_server
  end
end

describe "frank keyboard helper" do
  
  the_helper = nil
  before do
    the_helper = HelperForTesting.new
  end

  def successful_response
    %Q{ { "outcome": "SUCCESS" } }
  end

  it 'posts to the right endpoint' do
    the_helper.mock_frank_server.send_post('type_into_keyboard', anything ){ successful_response }

    the_helper.type_into_keyboard('blah')
  end

  it 'sends the right payload, adding a trailing new-line if needed' do
    the_helper.mock_frank_server.send_post.with_any_args do |endpoint,payload|
      payload.must_equal( {:text_to_type => "the text I want to type\n"} )

      successful_response
    end

    the_helper.type_into_keyboard('the text I want to type')
  end

  it "doesn't add a trailing newline if already there" do
    the_helper.mock_frank_server.send_post.with_any_args do |endpoint,payload|
      payload.must_equal( {:text_to_type => "existing newline\n"} )

      successful_response
    end

    the_helper.type_into_keyboard("existing newline\n")
  end

  it "doesn't add a trailing newline if asked explicitly not to" do
    the_helper.mock_frank_server.send_post.with_any_args do |endpoint,payload|
      payload.must_equal( {:text_to_type => "text without newline"} )

      successful_response
    end

    the_helper.type_into_keyboard("text without newline", :append_return => false)
  end

  it 'raises an exception if the server responds negatively' do
    failure_message = <<-EOS
    { 
      "outcome": "NOT SUCCESS AT ALL",
      "reason": "reason for failure",
      "details": "details about failure"
    }
    EOS

    the_helper.mock_frank_server.send_post.with_any_args{ failure_message }

    exception = lambda{ 
      the_helper.type_into_keyboard('text we attempted to type')
    }.must_raise RuntimeError
    
    exception.message.must_match /text we attempted to type/ 
    exception.message.must_match /reason for failure/ 
    exception.message.must_match /details about failure/ 
  end

end
