Feature: 
  In order to write automated acceptance tests for various devices and orientations
  As a tester
  I want Frank to be able to automate controls which use the iOS keyboard for data entry

Scenario Outline: typing using the keyboard in different devices and orientations
  When I launch the app using the <idiom> simulator
	And the device is in <orientation> orientation
  And I wait for nothing to be animating
	And I am on a fresh Data Entry screen
	Then I should be able to enter "some text" correctly using the keyboard

  Examples:
    | idiom  | orientation |
    | iphone | portrait    |
    | iphone | landscape   |
    | ipad   | portrait    |
    | ipad   | landscape   |
