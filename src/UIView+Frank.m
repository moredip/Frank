//
//  UIView+Frank.m
//  Frank
//
//  Created by Thoughtworks on 7/7/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//


#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(UIView_Frank)

@implementation UIView (Frank)

// Based on UISpec's flash method
- (void) FEX_flash{
	UIColor *originalBackgroundColor = [self.backgroundColor retain];
    CGFloat orginalAlpha = self.alpha;
    for (NSUInteger i = 0; i < 5; i++) {
        self.backgroundColor = [UIColor yellowColor];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
        
        self.alpha = 0;
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
        
        self.backgroundColor = [UIColor blueColor];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
        
        self.alpha = 1;
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
    }
    self.alpha = orginalAlpha;
    self.backgroundColor = originalBackgroundColor;
    [originalBackgroundColor release];
}

- (BOOL) FEX_isVisible{
    if( [self isHidden] )
        return false;
    
    if( [self superview] ){
        return [[self superview] FEX_isVisible];
    }else{
        return true;
    }
}

@end
