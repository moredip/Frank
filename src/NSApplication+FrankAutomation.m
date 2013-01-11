//
//  NSApplication+FrankAutomation.m
//  Frank
//
//  Created by Buckley on 12/5/12.
//
//

#import <Foundation/Foundation.h>

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(NSApplication_FrankAutomation)

@implementation NSApplication (FrankAutomation)

- (CGRect) FEX_accessibilityFrame {
    CGFloat maxWidth  = 0;
    CGFloat maxHeight = 0;
    
    for (NSScreen* screen in [NSScreen screens])
    {
        NSRect  frame  = [screen frame];
        CGFloat width  = frame.origin.x + frame.size.width;
        CGFloat height = frame.origin.y + frame.size.height;
        
        maxWidth  = MAX(width, maxWidth);
        maxHeight = MAX(height, maxHeight);
    }
    
    return CGRectMake(0, 0, maxWidth, maxHeight);
}

@end
