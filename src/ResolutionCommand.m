//
//  ResolutionCommand.m
//  Frank
//
//  Created by Buckley on 4/7/13.
//
//

#import "ResolutionCommand.h"
#import "JSON.h"

#if !TARGET_OS_IPHONE
#import "NSApplication+FrankAutomation.h"
#endif

@implementation ResolutionCommand

- (NSString *) handleCommandWithRequestBody:(NSString *) requestBody {
    
    CGSize  resolution = CGSizeMake(0, 0);
    CGFloat scale      = 0.0;
    
#if TARGET_OS_IPHONE
    scale             = [[UIScreen mainScreen] scale];
    resolution        = [[UIScreen mainScreen] bounds].size;
    resolution.width  = resolution.width * scale;
    resolution.height = resolution.height * scale;
#else
    resolution = [[NSApplication sharedApplication] FEX_accessibilityFrame].size;
    // TODO: Revisit to see if CGEvent and accessibility APIs on OS X have been
    // updated to use points instead of pixels.
    scale      = 1.0;
#endif
    
    NSDictionary* response = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: resolution.width],  @"width",
                              [NSNumber numberWithFloat: resolution.height], @"height",
                              [NSNumber numberWithFloat: scale],             @"scale",
                              nil];
    
    return TO_JSON(response);
}

@end
