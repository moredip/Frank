module Frank
module Cucumber

module KeyboardHelper
  def type_into_keyboard(text_to_type)
    text_to_type = text_to_type+"\n" unless text_to_type.end_with?("\n")
    res = frank_server.send_post( 
      'type_into_keyboard',
      :text_to_type => text_to_type
    )
    Frank::Cucumber::Gateway.evaluate_frankly_response( res, "typing the following into the keyboard '#{text_to_type}'" )
  end
end
end end
