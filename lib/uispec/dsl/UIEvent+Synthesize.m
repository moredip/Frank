//
//  UIEvent+Synthesis.m
//  UIExperiment
//
//  Created by Larivain, Olivier on 6/21/11.
//  Copyright 2011 Edmunds. All rights reserved.
//
#import <objc/runtime.h>
#import "UIEvent+Synthesize.h"
#import "GSEvent.h"
//
// GSEvent is an undeclared object. We don't need to use it ourselves but some
// Apple APIs (UIScrollView in particular) require the x and y fields to be present.
//
@interface GSEventProxy : NSObject
{
@public
	unsigned int flags;
	unsigned int type;
	unsigned int ignored1;
	float x1;
	float y1;
	float x2;
	float y2;
	unsigned int ignored2[10];
	unsigned int ignored3[7];
	float sizeX;
	float sizeY;
	float x3;
	float y3;
	unsigned int ignored4[3];
}
@end
@implementation GSEventProxy
@end

@interface UIEvent (Compiler_warnings_private)
// just to shut the compiler up, private we don't want to expose GSEventRef
// to the rest of the project
- (id)_initWithEvent:(GSEventProxy *)fp8 touches:(id)fp12;
- (void) _setGSEvent:(GSEventRef) eventRef;
@end

@implementation UIEvent (UIEvent_Synthesize)

+ (NSDictionary*) recordDictionaryForViewLocation: (CGPoint) viewLocation andWindowLocation: (CGPoint) windowLocation
{
    NSMutableDictionary *eventRecordDict = [NSMutableDictionary dictionaryWithCapacity:4];
    
    // new timestamp
    NSNumber *timestamp = [NSNumber numberWithLong: [[NSDate date] timeIntervalSince1970]];
    [eventRecordDict setObject:timestamp forKey:@"Time"];
    
    // location in view dictionary
    NSMutableDictionary *viewLocationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [viewLocationDict setObject:[NSNumber numberWithFloat: viewLocation.x] forKey:@"X"];
    [viewLocationDict setObject:[NSNumber numberWithFloat:viewLocation.y ] forKey:@"Y"];
    [eventRecordDict setObject:viewLocationDict forKey:@"Location"];
    
    // location in window dictionary
    NSMutableDictionary *windowDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [windowDict setObject:[NSNumber numberWithFloat: windowLocation.x] forKey:@"X"];
    [windowDict setObject:[NSNumber numberWithFloat:windowLocation.y ] forKey:@"Y"];
    [eventRecordDict setObject:windowDict forKey:@"WindowLocation"];
    
    // event type (touch)
    NSNumber *type = [NSNumber numberWithInt: kGSEventHand];
    [eventRecordDict setObject: type forKey:@"Type"];

    return eventRecordDict;
}

+ (id) applicationEventWithTouch: (UITouch *) touch
{    
    UIEvent *event = [[UIApplication sharedApplication] _touchesEvent];
    
    UIWindow *window = touch.window;
    CGPoint windowLocation = [touch locationInView: window];
    CGPoint viewLocation = [touch locationInView: touch.view];
    
    CFDictionaryRef recordDictionary = (CFDictionaryRef) [UIEvent recordDictionaryForViewLocation:viewLocation andWindowLocation: windowLocation];
    GSEventRef eventRef = GSEventCreateWithPlist(recordDictionary);
    
    [event _setGSEvent: eventRef];
    [event _addTouch: touch forDelayedDelivery: NO];
       
    return event;
}

- (id) initWithTouch: (UITouch *)touch
{
    CGPoint location = [touch locationInView:touch.window];
	GSEventProxy *gsEventProxy = [[GSEventProxy alloc] init];
	gsEventProxy->x1 = location.x;
	gsEventProxy->y1 = location.y;
	gsEventProxy->x2 = location.x;
	gsEventProxy->y2 = location.y;
	gsEventProxy->x3 = location.x;
	gsEventProxy->y3 = location.y;
	gsEventProxy->sizeX = 1.0;
	gsEventProxy->sizeY = 1.0;
	gsEventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
	gsEventProxy->type = 3001;	
	
	//
	// On SDK versions 3.0 and greater, we need to reallocate as a
	// UITouchesEvent.
	//
	Class touchesEventClass = objc_getClass("UITouchesEvent");
	if (touchesEventClass && ![[self class] isEqual:touchesEventClass])
	{
		[self release];
		self = [touchesEventClass alloc];
	}
	
	self = [self _initWithEvent:gsEventProxy touches: [NSMutableSet setWithObject: touch]];
	if (self != nil)
	{
	}
	return self;

}
- (void) updateTimestamp
{
    [self _setTimestamp: [[NSProcessInfo processInfo] systemUptime]];
}

@end
