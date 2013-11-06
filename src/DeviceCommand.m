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
    NSString* osVersion = nil;
    
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
    osVersion = [[UIDevice currentDevice] systemVersion];
#else
    device = @"mac";
    osVersion = [NSString stringWithFormat:@"%.2f", NSAppKitVersionNumber];
#endif
  
    NSArray* objects = [NSArray arrayWithObjects:device, osVersion, nil];
    NSArray* keys = [NSArray arrayWithObjects:@"device", @"os_version", nil];

    return TO_JSON ([NSDictionary dictionaryWithObjects:objects forKeys:keys]);
}

@end
