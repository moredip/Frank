//
//  UTouch+Synthesize.m
//  Frank
//
//  Created by Larivain, Olivier on 6/23/11.
//  Copyright 2011 Edmunds. All rights reserved.
//

#import "UITouch+Synthesize.h"


@implementation UITouch (UTouch_Synthesize)

// Main init
- (id)initInWindow:(UIWindow *)targetWindow withLocation:(CGPoint)location
{
	self = [super init];
	if (self != nil)
	{	
		UIView *targetView = [targetWindow hitTest:location withEvent:nil];

		_tapCount = 1;
		_locationInWindow = location;
		_previousLocationInWindow = _locationInWindow;
				
		_window = [targetWindow retain];
		_view = [targetView retain];
		_phase = UITouchPhaseBegan;
		_touchFlags._firstTouchForView = 1;
		_touchFlags._isTap = 1;
		_timestamp = [NSDate timeIntervalSinceReferenceDate];
	}
	return self;
}

+ (id) touchInView: (UIView*) view
{
	return [[[UITouch alloc] initInView:view] autorelease];
}

+ (id) touchAtPoint: (CGPoint) point
{
    // find hit view
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *view = [keyWindow hitTest: point withEvent: nil];
    
    UITouch *touch = [[[UITouch alloc] init] autorelease];
    // setup appropriate fields
    [touch setTapCount: 1];
    [touch setPhase: UITouchPhaseBegan];
    [touch setIsTap: YES];
    [touch _setLocationInWindow: point resetPrevious: YES];
    [touch setView: view];
    [touch setWindow: view.window];
    
    return  touch;
}

//
// initInView:phase:
//
// Creats a UITouch, centered on the specified view, in the view's window.
// Sets the phase as specified.
//
- (id)initInView:(UIView *)view
{
	CGRect frameInWindow;
	if ([view isKindOfClass:[UIWindow class]])
	{
		frameInWindow = view.frame;
	}
	else
	{
		frameInWindow =
		[view.window convertRect:view.frame fromView:view.superview];
	}
	
	CGPoint centerOfViewInWindowCoords = CGPointMake(
				frameInWindow.origin.x + 0.5 * frameInWindow.size.width,
				frameInWindow.origin.y + 0.5 * frameInWindow.size.height);
	
	return [self initInWindow:view.window withLocation:centerOfViewInWindowCoords];
}


- (id)initInView:(UIView *)view xcoord:(int)x ycoord:(int)y
{
	CGRect frameInWindow;
	if ([view isKindOfClass:[UIWindow class]])
	{
		frameInWindow = view.frame;
	}
	else
	{
		frameInWindow =
		[view.window convertRect:view.frame fromView:view.superview];
	}
	CGPoint locationInWindowCoords = CGPointMake(
					frameInWindow.origin.x + x,
					frameInWindow.origin.y + y);
	
	return [self initInWindow:view.window withLocation:locationInWindowCoords];
}

//
// setPhase:
//
// Setter to allow access to the _phase member.
//
- (void)setPhase:(UITouchPhase)phase
{
	_phase = phase;
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
}

//
// setPhase:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
	_previousLocationInWindow = _locationInWindow;
	_locationInWindow = location;
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
}

@end
