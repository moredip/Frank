CAROUSEL_SELECTOR_FRAGMENT = "view:'Carousel'"
PORTRAIT_IPHONE_WIDTH = 320
PORTRAIT_IPHONE_HEIGHT = 480

When /^I page the carousel to the right$/ do
  frankly_map( "#{CAROUSEL_SELECTOR_FRAGMENT}", 'swipeInDirection:', 'left' )
end

Then /^I see the (\d+)(?:st|nd|rd|th) image in the carousel$/ do |ordinal|
  index = ordinal.to_i - 1
  subject_image = "image#{index}.jpg"
 
  image_frame_as_json = frankly_map("#{CAROUSEL_SELECTOR_FRAGMENT} view:'UIScrollView' view:'UIImageView' marked:'#{subject_image}'", 'accessibilityFrame').first
  left_side_of_image = image_frame_as_json["origin"]["x"]
  right_side_of_image = left_side_of_image + image_frame_as_json["size"]["width"]
  left_side_of_image.should >= 0
  left_side_of_image.should <= PORTRAIT_IPHONE_WIDTH
  right_side_of_image.should >= 0
  right_side_of_image.should <= PORTRAIT_IPHONE_WIDTH
end
