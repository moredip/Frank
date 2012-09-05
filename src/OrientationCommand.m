//
//  OrientationCommand.m
//  Chase.Mobi
//
//  Created by Pete Hodgson on 9/21/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "OrientationCommand.h"
#import "NSObject+Franks_SBJSON.h"

#import "PublicAutomation/PublicAutomation.h"
#import "FranklyProtocolHelper.h"


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

- (NSString *)handleGet{
   	NSString *orientationDescription = [self getOrientationDescriptionViaDevice];
    if( !orientationDescription )
        orientationDescription = [self getOrientationDescriptionViaStatusBar];
	
	NSDictionary *dom = [NSDictionary dictionaryWithObject:orientationDescription forKey:@"orientation"];
	return [dom JSONRepresentation];
}

- (NSString *)handlePost:(NSString *)requestBody{
    requestBody = [requestBody lowercaseString];
    
    UIDeviceOrientation requestedOrientation = UIDeviceOrientationUnknown;
    if( [requestBody isEqualToString:@"landscape_right"] ){
        requestedOrientation = UIDeviceOrientationLandscapeRight;
    }else if( [requestBody isEqualToString:@"landscape_left"] ){
        requestedOrientation = UIDeviceOrientationLandscapeLeft;
    }else if( [requestBody isEqualToString:@"portrait"] ){
        requestedOrientation = UIDeviceOrientationPortrait;
    }else if( [requestBody isEqualToString:@"portrait_upside_down"] ){
        requestedOrientation = UIDeviceOrientationPortraitUpsideDown;
    }
    
    if( requestedOrientation == UIDeviceOrientationUnknown){
        return [FranklyProtocolHelper generateErrorResponseWithReason:@"unrecognized orientation"
                                                           andDetails:[NSString stringWithFormat:@"orientation '%@' is invalid. Use 'landscape_right','landscape_left','portrait', or 'portrait_upside_down'", requestBody]];
    }

    [UIAutomationBridge setOrientation:requestedOrientation];
    
    return nil;
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    if( !requestBody || [requestBody isEqualToString:@""] )
        return [self handleGet];
    else
        return [self handlePost:requestBody];
}

@end