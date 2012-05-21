When /^I type "([^"]*)" into the "([^"]*)" text field using the keyboard$/ do |text_to_type, placeholder|
  touch( "textField placeholder:'#{placeholder}'" )
  sleep(0.2) # wait for keyboard to animate in
  wait_for_nothing_to_be_animating

  #type_into_keyboard( text_to_type )

  text_to_type = text_to_type+"\n" unless text_to_type.end_with?("\n")
  res = frank_server.send_post( 
    'type_into_keyboard',
    :text_to_type => text_to_type,
  )
  Frank::Cucumber::Gateway.evaluate_frankly_response( res, "typing the following into the keyboard '#{text_to_type}'" )
end
