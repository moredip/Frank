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
    BOOL isRetina = ([[UIScreen mainScreen] scale] == 2.0);
    
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPhone:
            if (isRetina) {
                BOOL isTall = ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON ); // from http://stackoverflow.com/questions/12446990/how-to-detect-iphone-5-widescreen-devices
                
                if (isTall) {
                    device = @"retina iphone (4 inch)";
                }else{
                    device = @"retina iphone (3.5 inch)";
                }
            }else{
                device = @"iphone";
            }
            break;
            
        case UIUserInterfaceIdiomPad:
            if (isRetina) {
                device = @"retina ipad";
            }else{
                device = @"ipad";
            }
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
