module Frank
module Cucumber

module KeyboardHelper
  # Ask Frank to press a sequence of keys on the iOS keyboard.
  #
  # @note The keyboard must be fully visible on the device before calling this method.
  #
  # The "/b" control character is interpreted as a request to press the 'Delete' key.
  #
  # An implicit return is appended to the key sequence, unless you specify otherwise by passing an {:append_return => false} option.
  #
  # @example
  #   # press the X, -, Y, and z keys on the 
  #   # iOS keyboard, then press return
  #   type_into_keyboard("X-Yz")
  #
  #   # press the 1, 2, and 3 keys on the 
  #   # iOS keyboard, but don't press return afterwards
  #   type_into_keyboard("123", :append_return => false)
  #
  #   # press the 1, 2, and 3 keys on the 
  #   # iOS keyboard, but don't press return afterwards
  #   type_into_keyboard("123", :append_return => false)
  #
  #   # press Delete twice, then type "foo"
  #   type_into_keyboard("\b\bfoo")
  #
  def type_into_keyboard(text_to_type, options = {})
    options = {
      :append_return => true
    }.merge(options)

    if( options[:append_return] )
      text_to_type = text_to_type+"\n" unless text_to_type.end_with?("\n")
    end
    res = frank_server.send_post( 
      'type_into_keyboard',
      :text_to_type => text_to_type
    )
    Frank::Cucumber::Gateway.evaluate_frankly_response( res, "typing the following into the keyboard '#{text_to_type}'" )
  end
end
end end
