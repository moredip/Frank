Then(/^the opaque green view should be user visible$/) do
  wait_for_element_to_exist_and_be_user_visible(green_view)
end

Then(/^the occluded yellow view should not be user visible$/) do
  wait_for_element_to_exist_and_not_be_user_visible(yellow_view)
end

def wait_for_element_to_exist_and_be_user_visible(selector)
  wait_for_element_to_exist("#{selector} FEX_isUserVisible")
end

def wait_for_element_to_exist_and_not_be_user_visible(selector)
  wait_for_element_to_exist("#{selector}")
  wait_for_element_to_not_exist("#{selector} FEX_isUserVisible")
end

def view_colored(color)
  "view marked:'#{color}'"
end

def green_view
  view_colored('green')
end

def yellow_view
  view_colored('yellow')
end

def orange_view
  view_colored('orange')
end

def wait_for_square_view_of_color_to_exist_and_be_user_visible(color)
  wait_for_element_to_exist("#{view_colored(color)} FEX_isUserVisible")
end

def wait_for_square_view_of_color_to_exist_and_not_be_user_visible(color)
  wait_for_element_to_exist("#{view_colored(color)}")
  check_element_does_not_exist("#{view_colored(color)} FEX_isUserVisible")
end

Then(/^the partially transparent orange view should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:orange)
end

Then(/^the purple view below should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:purple)
end

Then(/^the opaque cyan view should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:cyan)
end

Then(/^the blue view partially below should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:blue)
end

Then(/^the opaque magenta view should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:magenta)
end

Then(/^the black view below should not be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_not_be_user_visible(:black)
end

Then(/^the brown subview of the black view should not be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_not_be_user_visible(:brown)
end

Then(/^the gray square should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:gray)
end

Then(/^the clear superview of the above should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:clear)
end

Then(/^the pink view below should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:pink)
end

Then(/^the pink view below should not be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_not_be_user_visible(:pink)
end

Then(/^the clear view incorrectly marked opaque should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible('clear-opaque')
end

Then(/^the clear square should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible(:clear)
end

Then(/^the sea foam view below should be user visible$/) do
  wait_for_square_view_of_color_to_exist_and_be_user_visible('sea foam')
end