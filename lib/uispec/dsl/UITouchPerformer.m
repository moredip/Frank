//
//  UIQueryGestureDelegate.m
//  Frank
//
//  Created by Larivain, Olivier on 6/23/11.
//  Copyright 2011 Edmunds. All rights reserved.
//

#import "UITouchPerformer.h"

#import "UITouch+Synthesize.h"
#import "UIEvent+Synthesize.h"

#import "VisibleTouch.h"

#define TAP_DELAY 0.1
#define GESTURES_DELAY 0.01

@interface UITouchPerformer()
- (CGPoint) keepPointInDeviceBounds: (CGPoint) point;
-(void) wait:(double)seconds;
@end

@implementation UITouchPerformer

+ (id) touchPerformer
{
    return [[[UITouchPerformer alloc] init] autorelease];
}

#pragma mark - Tapping
- (void) tapOnViews: (NSArray*) views
{
    for(UIView *targetView in views)
    {
        // create a touch in the center of the view
        UITouch *touch = [UITouch touchInView: targetView];
				
		VisibleTouch *visibleTouch = [[VisibleTouch alloc] initWithCenter:[targetView.superview convertPoint:targetView.center toView:nil]];
		[visibleTouch addToKeyWindow];
		        
        // init an empty event
        UIEvent *event = [UIEvent applicationEventWithTouch: touch];
        // populate the event
        [event _addGestureRecognizersForView: targetView toTouch: touch];    
        [event updateTimestamp];
        
        // dispatch phase down event
        [[UIApplication sharedApplication] sendEvent: event];
        
        [self wait: TAP_DELAY];
        
        // dispatch phase up
        [touch setPhase:UITouchPhaseEnded];
        [event updateTimestamp];
        [[UIApplication sharedApplication] sendEvent: event];
	
		[visibleTouch removeFromSuperview];
		[visibleTouch release];
    }
}

- (void) tapAtPoint: (CGPoint) point
{
    NSLog(@"Tapping at: %@", NSStringFromCGPoint(point));

    UITouch *touch = [UITouch touchAtPoint: point];
	
	VisibleTouch *visibleTouch = [[VisibleTouch alloc] initWithCenter:point];
	[visibleTouch addToKeyWindow];

    
    // init an empty event
    UIEvent *event = [UIEvent applicationEventWithTouch: touch];
    // populate the event
    [event _addGestureRecognizersForView: touch.view toTouch: touch];    
    [event updateTimestamp];
    
    // dispatch phase down event
    [[UIApplication sharedApplication] sendEvent: event];
    
    [self wait: TAP_DELAY];
    
    // dispatch phase up
    [touch setPhase:UITouchPhaseEnded];
    [event updateTimestamp];
    [[UIApplication sharedApplication] sendEvent: event];
	
	[visibleTouch removeFromSuperview];
	[visibleTouch release];
}

#pragma mark - Swiping
// swipes from center of each view in the given direction
- (void)swipeInViews: (NSArray*) views direction: (SwipeDirection) direction
{
    for(UIView *view in views)
    {
        // grab center of view.
        CGPoint start = [view convertPoint: [view center] toView: nil];

        // now swipe in direction
        [self swipeAt: start direction: direction];
        [self wait: 0.1];
    }
}

- (void)swipeAt: (CGPoint) start direction: (SwipeDirection) direction
{
    // initialize to start, just to prevent weird behavior in case end
    // ends not initialized
    CGPoint end = CGPointMake(start.x, start.y);
    switch (direction) {
        case SwipeDirectionLeft:
            end = CGPointMake(start.x - 80, start.y + 5);
            break;
        case SwipeDirectionRight:
            end = CGPointMake(start.x + 80, start.y + 5);
            break;
        case SwipeDirectionUp:
            end = CGPointMake(start.x + 5, start.y - 80);
            break;
        case SwipeDirectionDown:
            end = CGPointMake(start.x + 5, start.y + 80);
            break;
		default:
			[NSException raise:@"Invalid swipe direction" format:@"Must be one of Left, Right, Up, or Down"];
    }
    
    // now go for actual swipe
    [self swipeFrom: start to: end];
}

// swipes from start to end
- (void)swipeFrom: (CGPoint) start to: (CGPoint) end
{
    start = [self keepPointInDeviceBounds: start];
    end = [self keepPointInDeviceBounds: end];
    // create initial touch and UIEvent
    UITouch *touch = [UITouch touchAtPoint: start];
    
    UIEvent *event = [UIEvent applicationEventWithTouch: touch];
    [event _addGestureRecognizersForView: touch.view toTouch: touch];
    
    // dispatch touch down
    [[UIApplication sharedApplication] sendEvent: event];
    
    // we'll dispatch 10 move events.
    int numberOfSteps = 10;
    
    // compute x and y offset per step
    CGFloat xLength = end.x - start.x;
    CGFloat xOffset = xLength / numberOfSteps;
    
    CGFloat yLength = end.y - start.y;
    CGFloat yOffset = yLength / numberOfSteps;
	
	// Create a view to display a visible touch on the screen with a center of the touch
	VisibleTouch *visibleTouch = [[VisibleTouch alloc] initWithCenter:start];
	[visibleTouch addToKeyWindow];
    
    // create the new location for every step, create event and dispatch it
    for(int i = 0; i < numberOfSteps; i++)
    {
        [self wait: GESTURES_DELAY];
        CGFloat newX = start.x + (i+1) * xOffset;
        CGFloat newY = start.y + (i+1) * yOffset;
        CGPoint newLocation = CGPointMake(newX, newY);
        [touch setLocationInWindow: newLocation];
        [touch setPhase: UITouchPhaseMoved];
        
        [event updateTimestamp];
        
        [[UIApplication sharedApplication] sendEvent: event];
		
		visibleTouch.center = newLocation;
    }
    
    [self wait: 0.01];
    // don't forget phase ended touch
    [touch setPhase:UITouchPhaseEnded];
    
    [event updateTimestamp];
    [[UIApplication sharedApplication] sendEvent: event];
	
	[visibleTouch removeFromSuperview];
	[visibleTouch release];
}

#pragma mark - Pinching
- (void) pinchFrom: (CGRect) start to: (CGRect) end
{
    // grab corners from start and end rect
    CGPoint lowerLeftStartPoint = CGPointMake(CGRectGetMinX(start), CGRectGetMaxY(start));
    CGPoint upperRightStartPoint = CGPointMake(CGRectGetMaxX(start), CGRectGetMinY(start)); 

    // create touches at those points
    UITouch *lowerLeftTouch = [UITouch touchAtPoint: lowerLeftStartPoint];
    UITouch *upperRightTouch = [UITouch touchAtPoint: upperRightStartPoint];
    
    // build event with lower left touch, add gesture recognizers for that touch
    // and then add upper right touch, along with it's gesture recognizers
    UIEvent *event = [UIEvent applicationEventWithTouch: lowerLeftTouch];
    [event _addGestureRecognizersForView: lowerLeftTouch.view toTouch: lowerLeftTouch];

    [event _addTouch: upperRightTouch forDelayedDelivery: NO];
    [event _addGestureRecognizersForView: upperRightTouch.view toTouch: upperRightTouch];

    // dispatch touch down event
    [[UIApplication sharedApplication] sendEvent:event];
    
    // we'll dispatch 10 move events.
    int numberOfSteps = 15;
    
    // now, compute offsets
    // first lower left corner
    CGPoint lowerLeftEndPoint = CGPointMake(CGRectGetMinX(end), CGRectGetMaxY(end));
    
    CGFloat lowerLeftXLength = lowerLeftEndPoint.x - lowerLeftStartPoint.x;
    CGFloat lowerLeftXOffset = lowerLeftXLength / numberOfSteps;
    
    CGFloat lowerLeftYLength = lowerLeftEndPoint.y - lowerLeftStartPoint.y;
    CGFloat lowerLeftYOffset = lowerLeftYLength / numberOfSteps;
    
    // now upper right corner
    CGPoint upperRightEndPoint = CGPointMake(CGRectGetMaxX(end), CGRectGetMinY(end)); 
    
    CGFloat upperRightXLength = upperRightEndPoint.x - upperRightStartPoint.x;
    CGFloat upperRightXOffset = upperRightXLength / numberOfSteps;
    
    CGFloat upperRightYLength = upperRightEndPoint.y - upperRightStartPoint.y;
    CGFloat upperRightYOffset = upperRightYLength / numberOfSteps;
    
    for(int i = 0; i < numberOfSteps; i++)
    {
        [self wait: GESTURES_DELAY];
        // move lower left touch
        CGFloat newLowerLeftX = lowerLeftStartPoint.x + (i+i) * lowerLeftXOffset;
        CGFloat newLowerLeftY = lowerLeftStartPoint.y + (i+i) * lowerLeftYOffset;
        CGPoint newLowerLeftLocation = CGPointMake(newLowerLeftX, newLowerLeftY);
        
        [lowerLeftTouch setLocationInWindow: newLowerLeftLocation];
        [lowerLeftTouch setPhase: UITouchPhaseMoved];
        
        // move upper left touch
        CGFloat newUpperRightX = upperRightStartPoint.x + (i+i)*upperRightXOffset;
        CGFloat newUpperRightY = upperRightStartPoint.y + (i+i)*upperRightYOffset;
        CGPoint newUpperRightLocation = CGPointMake(newUpperRightX, newUpperRightY);
        
        [upperRightTouch setLocationInWindow: newUpperRightLocation];
        [upperRightTouch setPhase: UITouchPhaseMoved];
        
        [[UIApplication sharedApplication] sendEvent:event];
    }
    
    [self wait: GESTURES_DELAY];
    [lowerLeftTouch setPhase: UITouchPhaseEnded];
    [upperRightTouch setPhase: UITouchPhaseEnded];
    
    [[UIApplication sharedApplication] sendEvent:event];
}

#pragma mark - Private utility methods
- (CGPoint) keepPointInDeviceBounds: (CGPoint) point
{
    CGRect frame = [[[UIApplication sharedApplication] keyWindow] frame];
    if(CGRectContainsPoint(frame, point))
    {
        return point;
    }
    
    if(point.x < 0)
    {
        point.x = 0;
    }
    
    if(point.x > frame.size.width)
    {
        point.x = frame.size.width - 1;
    }
    
    
    if(point.y < 0)
    {
        point.y = 0;
    }
    
    if(point.y > frame.size.height)
    {
        point.y = frame.size.height - 1;
    }
}

#pragma mark - Legacy
- (void) touchViews: (NSArray*) targetViews atPoint: (CGPoint) point
{
    for (UIView *aView in targetViews) {
		UITouch *aTouch = [[UITouch alloc] initInView:aView xcoord:point.x ycoord:point.y];
        
        // Create a view to display a visible touch on the screen with a center of the touch
        UIView *visibleTouch = [[VisibleTouch alloc] initWithCenter: point];
        [[aView window] addSubview:visibleTouch];
        [[aView window] bringSubviewToFront:visibleTouch];
        
		UIEvent *eventDown = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:aTouch];
		NSSet *touches = [[NSMutableSet alloc] initWithObjects:&aTouch count:1];
		
		[aTouch.view touchesBegan:touches withEvent:eventDown];
        
        // Send event to the gesture recognizers
        for (UIGestureRecognizer *recognizer in [aView gestureRecognizers])
        {
            if(![recognizer respondsToSelector:@selector(touchesBegan:withEvent:)])
            {
                continue;
            }

            [recognizer touchesBegan:touches withEvent:eventDown];
        }
        
        [self wait:.25]; // Pause so touch can be seen
        
		UIEvent *eventUp = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:aTouch];
		[aTouch setPhase:UITouchPhaseEnded];
		
		[aTouch.view touchesEnded:touches withEvent:eventDown];
        
        for (UIGestureRecognizer *recognizer in [aView gestureRecognizers])
        {
            if(![recognizer respondsToSelector:@selector(touchesEnded:withEvent:)])
            {
                continue;
            }

            [recognizer touchesEnded:touches withEvent:eventDown];
        }
        
        [visibleTouch removeFromSuperview];
        [visibleTouch release];
        
		[eventDown release];
		[eventUp release];
		[touches release];
		[aTouch release];
		[self wait:.5];
	}

}

- (void) touch:(NSArray*) targetViews
{
    for (UIView *targetView in targetViews) {
		UITouch *targetTouch = [[UITouch alloc] initInView:targetView];
		UIEvent *eventDown = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:targetTouch];
		NSSet *touches = [NSMutableSet setWithObject: targetTouch];
		
		[targetTouch.view touchesBegan:touches withEvent:eventDown];
		
		[targetTouch setPhase:UITouchPhaseEnded];
		
		[targetTouch.view touchesEnded:touches withEvent:eventDown];
		
		[eventDown release];
		[targetTouch release];
	}
}

-(void) wait:(double)seconds 
{
	CFRunLoopRunInMode(kCFRunLoopDefaultMode, seconds, false);
}

@end
