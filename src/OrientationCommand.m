//
//  OrientationCommand.m
//  Chase.Mobi
//
//  Created by Pete Hodgson on 9/21/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "OrientationCommand.h"

#import <PublicAutomation/UIAutomationBridge.h>
#import "FranklyProtocolHelper.h"
#import "JSON.h"


@implementation OrientationCommand

- (NSDictionary *)representOrientation:(NSString *)orientation withDetailedOrientation:(NSString *)detailedOrientation{
    return [NSDictionary dictionaryWithObjectsAndKeys:orientation,@"orientation", detailedOrientation,@"detailed_orientation",nil];
}

- (NSDictionary *)getOrientationRepresentationViaStatusBar{
    switch([[UIApplication sharedApplication] statusBarOrientation]){
		case UIInterfaceOrientationLandscapeLeft:
            return [self representOrientation:@"landscape" withDetailedOrientation:@"landscape_left"];
		case UIInterfaceOrientationLandscapeRight:
            return [self representOrientation:@"landscape" withDetailedOrientation:@"landscape_right"];
		case UIInterfaceOrientationPortrait:
            return [self representOrientation:@"portrait" withDetailedOrientation:@"portrait"];
		case UIInterfaceOrientationPortraitUpsideDown:
            return [self representOrientation:@"portrait" withDetailedOrientation:@"portrait_upside_down"];
        default:
            NSLog(@"Device orientation via status bar is unknown");
            return nil;
    }
}

- (NSDictionary *)getOrientationRepresentationViaDevice{
    switch ( [UIDevice currentDevice].orientation ) {
		case UIDeviceOrientationLandscapeRight:
            return [self representOrientation:@"landscape" withDetailedOrientation:@"landscape_right"];
		case UIDeviceOrientationLandscapeLeft:
            return [self representOrientation:@"landscape" withDetailedOrientation:@"landscape_left"];
		case UIDeviceOrientationPortrait:
            return [self representOrientation:@"portrait" withDetailedOrientation:@"portrait"];
		case UIDeviceOrientationPortraitUpsideDown:
            return [self representOrientation:@"portrait" withDetailedOrientation:@"portrait_upside_down"];
        case UIDeviceOrientationFaceUp:
            NSLog(@"Device orientation is face up");
            return nil;
        case UIDeviceOrientationFaceDown:
            NSLog(@"Device orientation is face down");
            return nil;
        default:
            NSLog(@"Device orientation via device is unknown");
            return nil;
	}
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
   	NSDictionary *orientationDescription = [self getOrientationRepresentationViaDevice];
    if( !orientationDescription )
        orientationDescription = [self getOrientationRepresentationViaStatusBar];
	
	return TO_JSON(orientationDescription);
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
    
    return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    if( !requestBody || [requestBody isEqualToString:@""] )
        return [self handleGet];
    else
        return [self handlePost:requestBody];
}

@end