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
@interface NSApplication ()
- (CGRect) FEX_accessibilityFrame;
@end
#endif

@implementation ResolutionCommand

- (NSString *) handleCommandWithRequestBody:(NSString *) requestBody {
    
    CGSize resolution = CGSizeMake(0, 0);
    
#if TARGET_OS_IPHONE
    CGFloat scale     = [[UIScreen mainScreen] scale];
    resolution        = [[UIScreen mainScreen] bounds].size;
    resolution.width  = resolution.width * scale;
    resolution.height = resolution.height * scale;
#else
    resolution = [[NSApplication sharedApplication] FEX_accessibilityFrame].size;
#endif
    
    NSDictionary* response = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: resolution.width],  @"width",
                              [NSNumber numberWithFloat: resolution.height], @"height",
                              nil];
    
    return TO_JSON(response);
}

@end
