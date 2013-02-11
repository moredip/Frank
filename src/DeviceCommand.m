//
//  DeviceCommand.m
//  Frank
//
//  Created by Buckley on 2/10/13.
//
//

#import "DeviceCommand.h"
#import "JSON.h"

@implementation DeviceCommand

- (NSString *) handleCommandWithRequestBody:(NSString *) requestBody {
    NSString* device = nil;
    
#if TARGET_OS_IPHONE
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPhone:
            device = @"iphone";
            break;
            
        case UIUserInterfaceIdiomPad:
            device = @"ipad";
            break;
            
        default:
            device = @"unknown";
            break;
    }
#else
    device = @"mac";
#endif
    
    return TO_JSON ([NSDictionary dictionaryWithObject: device forKey: @"device"]);
}

@end
