//
//  OrientationCommand.m
//  Chase.Mobi
//
//  Created by Pete Hodgson on 9/21/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "OrientationCommand.h"
#import "NSObject+SBJSON.h"


@implementation OrientationCommand

- (NSString *)getOrientationDescriptionViaStatusBar{
    if( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) )
        return @"portrait";
    else
        return @"landscape";
}

- (NSString *)getOrientationDescriptionViaDevice{
    switch ( [UIDevice currentDevice].orientation ) {
		case UIDeviceOrientationLandscapeRight:
		case UIDeviceOrientationLandscapeLeft:
			return @"landscape";
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
			return @"portrait";
        case UIDeviceOrientationFaceUp:
            NSLog(@"Device orientation is face up");
            //fall thru
        case UIDeviceOrientationFaceDown:
            NSLog(@"Device orientation is face down");
            //fall thru
        case UIDeviceOrientationUnknown:
            NSLog(@"Device orientation is unknown");
            //fall thru
		default:
            return nil;
	}
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {    
   	__block NSString *orientationDescription = nil;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        orientationDescription = [[self getOrientationDescriptionViaDevice] retain];
        
        if( !orientationDescription ) {
            orientationDescription = [[self getOrientationDescriptionViaStatusBar] retain];
        }
    });
    
    [orientationDescription autorelease];
	
	NSDictionary *dom = [NSDictionary dictionaryWithObject:orientationDescription forKey:@"orientation"];
	return [dom JSONRepresentation];
}

@end