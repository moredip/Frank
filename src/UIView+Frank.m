//
//  UIView+Frank.m
//  Frank
//
//  Created by Thoughtworks on 7/7/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "UIView+Frank.h"
#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(UIView_Frank)

@implementation UIView (Frank)

// Based on UISpec's flash method
- (void)FEX_flash {
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

- (BOOL)FEX_isVisible {
    if( [self isHidden] )
        return false;
    
    if( [self superview] ){
        return [[self superview] FEX_isVisible];
    }else{
        return true;
    }
}

- (BOOL)FEX_userVisible {
    return ![self FEX_userInvisible];
}

- (BOOL)FEX_userInvisible
{
    if (![self FEX_isVisible]) {
        return YES;
    }
    
    if ([self FEX_fullyOccludedByOpaqueSibling]) {
        return YES;
    }else{
        if ([self superview]) {
            return [[self superview] FEX_fullyOccludedByOpaqueSibling];
        }
    }

    return NO;
}

- (NSUInteger)FEX_positionInParentSubviews
{
    UIView *superview = [self superview];
    NSUInteger ourIndex = [superview.subviews indexOfObject:self];
    return ourIndex;
}

- (BOOL)FEX_isLastSubviewInParent
{
    UIView *superview = [self superview];
    NSUInteger ourIndex = [self FEX_positionInParentSubviews];
    NSUInteger lastPositionInParentSubviews = [superview.subviews count] - 1;
    
    return (ourIndex == lastPositionInParentSubviews);
}

- (NSArray *)FEX_siblingsAboveUs
{
    if ([self FEX_isLastSubviewInParent]) {
        return @[];
    }

    return [self FEX_superviewsSubviewsByMakingSubarrayUntilEnd];
}

- (NSArray *)FEX_superviewsSubviewsByMakingSubarrayUntilEnd
{
    UIView *superview = [self superview];
    NSUInteger nextIndex = [self FEX_positionInParentSubviews] + 1;
    // check here
    
    NSUInteger remainingElements = [[superview subviews] count]  - nextIndex;
    return [superview.subviews subarrayWithRange:NSMakeRange(nextIndex, remainingElements)];
}

- (BOOL)FEX_fullyOccludedByOpaqueSibling
{
    for (UIView *aSiblingAbove in [self FEX_siblingsAboveUs]) {
        if ([aSiblingAbove FEX_fullyOverlapsView:self] && [aSiblingAbove isOpaque] && [aSiblingAbove alpha] == 1.0) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)FEX_fullyOverlapsView:(UIView *)anotherView
{
    CGRect myFrameInWindowCoords = [self.window convertRect:self.bounds fromView:self];
    CGRect otherFrameInWindowCoords = [self.window convertRect:self.bounds fromView:anotherView];
    return CGRectContainsRect(myFrameInWindowCoords, otherFrameInWindowCoords);
}

- (BOOL)FEX_isFullyWithinWindow {
    CGRect myFrameInWindowCoords = [self.window convertRect:self.bounds fromView:self];
    return CGRectContainsRect(self.window.bounds, myFrameInWindowCoords);
}

@end
