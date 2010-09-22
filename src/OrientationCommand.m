//
//  OrientationCommand.m
//  Chase.Mobi
//
//  Created by Pete Hodgson on 9/21/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "OrientationCommand.h"


@implementation OrientationCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	NSString *orientationDescription = nil;
	switch ( [UIDevice currentDevice].orientation ) {
		case UIDeviceOrientationLandscapeRight:
		case UIDeviceOrientationLandscapeLeft:
			orientationDescription = @"landscape";
			break;
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
			orientationDescription = @"portrait";
			break;
		default:
			orientationDescription = @"flat";
	}
	
	NSDictionary *dom = [NSDictionary dictionaryWithObject:orientationDescription forKey:@"orientation"];
	return [dom JSONRepresentation];
}

@end