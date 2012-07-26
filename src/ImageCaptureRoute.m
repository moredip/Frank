//
//  ImageCaptureRoute.m
//  Frank
//
//  Created by Pete Hodgson on 7/26/12.
//  Copyright (c) 2012 Thoughtworks. All rights reserved.
//

#import "ImageCaptureRoute.h"

#import "UIImage+Frank.h"

@implementation ImageCaptureRoute

- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection{
    
    if( ![@"screenshot" isEqualToString:[path objectAtIndex:0]] )
        return nil;
    
    BOOL allWindows = [path count] > 1 && [[path objectAtIndex:1] isEqualToString:@"allwindows"];
    UIImage *screenshot = [UIImage imageFromApplication:allWindows];
    
    if ([path count] == 4)
    {
        NSString *stringRepresentation = [path objectAtIndex:3];
        NSArray *parts = [stringRepresentation componentsSeparatedByString:@"."];
        CGRect rect = CGRectZero;
        
        rect.origin.x = [[parts objectAtIndex:0] integerValue];
        rect.origin.y = [[parts objectAtIndex:1] integerValue];
        rect.size.width  = [[parts objectAtIndex:2] integerValue];
        rect.size.height = [[parts objectAtIndex:3] integerValue];
        
        //
        // Crop image or mask out an area (IE: Timestamp)
        //
        if ([[path objectAtIndex:2] isEqualToString:@"frame"])
            screenshot = [screenshot imageCropedToFrame:rect];
        else if ([[path objectAtIndex:2] isEqualToString:@"mask"])
            screenshot = [screenshot imageMaskedAtFrame:rect];
        else
            NSLog(@"Unknown Operation");
    }
    
    NSData *response = UIImagePNGRepresentation(screenshot);
    
    return [[[HTTPDataResponse alloc] initWithData:response] autorelease];
}

- (BOOL) canHandlePostForPath: (NSArray *)path{
    	return NO;
}

@end
