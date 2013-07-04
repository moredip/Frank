Feature: FEX_userVisible

Background:
  Given I launch the app
  And I touch "FEX_userVisible"

Scenario: view not user visible when completely occluded by a non-transparent sibling view
  Then the opaque green view should be user visible
  And the occluded yellow view should not be user visible

Scenario: view user visible when occluded by a partially transparent sibling view
  Then the partially transparent orange view should be user visible
  And the purple view below should be user visible

Scenario: view not user visible when occluded by a clear color sibling view incorrectly marked isOpaque
# It is a programming error to mark a view isOpaque that does not fill its bounds with opaque content.
  Then the gray square should be user visible
  And the clear view incorrectly marked opaque should be user visible
  And the pink view below should not be user visible
  
Scenario: view user visible when occluded by a non-opaque view
  Then the clear square should be user visible
  And the sea foam view below should be user visible

Scenario: view user visible when partially occluded
  Then the opaque cyan view should be user visible
  And the blue view partially below should be user visible

Scenario: view not user visible when superview completely occluded by a non-transparent sibling
  Then the opaque magenta view should be user visible
  And the black view below should not be user visible
  And the brown subview of the black view should not be user visible