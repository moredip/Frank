//
//  NSApplication+FrankAutomation.h
//  Frank
//
//  Created by Buckley on 4/22/13.
//
//

@interface NSApplication (FrankAutomation)

- (CGRect) FEX_accessibilityFrame;

- (void) FEX_startTrackingMenus;
- (NSSet*) FEX_menus;

@end
