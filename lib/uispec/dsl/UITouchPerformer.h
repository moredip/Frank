//
//  UIQueryGestureDelegate.h
//  Frank
//
//  Created by Larivain, Olivier on 6/23/11.
//  Copyright 2011 Edmunds. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SwipeDirection
{
    SwipeDirectionUp,
    SwipeDirectionLeft,
    SwipeDirectionDown,
    SwipeDirectionRight
} SwipeDirection;

@interface UITouchPerformer : NSObject 
{
}

+ (id) touchPerformer;

// touches given views in their center.
// This method is deprecated, it exists solely for backward compatibility with existing code.
// Beware that it'll work only in very limited case, as it is invoking directly
// touchesBegan/touchesEnded
- (void) touch: (NSArray*) views;
- (void) touchViews: (NSArray*) views atPoint: (CGPoint) point;

// gesture support

// Taps all views contained in views array. The touch point is the center of the view.
- (void) tapOnViews: (NSArray*) views;

// taps the screen at the given point, in window coordinates
- (void) tapAtPoint: (CGPoint) point;

// swipes from center of view in the given direction
- (void)swipeInViews: (NSArray*) view direction: (SwipeDirection) direction;

// swipes in given direction, starting at start point (window coordinates)
- (void)swipeAt: (CGPoint) start direction: (SwipeDirection) direction;

// swipes from start to end
- (void)swipeFrom: (CGPoint) start to: (CGPoint) end;

// pinches from start rect to end rect
- (void) pinchFrom: (CGRect) start to: (CGRect) end;

@end
