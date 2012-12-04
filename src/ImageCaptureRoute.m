//
//  ImageCaptureRoute.m
//  Frank
//
//  Created by Pete Hodgson on 7/26/12.
//  Copyright (c) 2012 Thoughtworks. All rights reserved.
//

#import "HTTPDataResponse.h"
#import "HTTPFileResponse.h"

#import "ImageCaptureRoute.h"
#import "RoutingHTTPConnection.h"

#if TARGET_OS_IPHONE
#import "UIImage+Frank.h"
#import "UIView+ImageCapture.h"
#else
#import "NSImage+Frank.h"
#import "NSView+FrankImageCapture.h"
#endif
#import "FranklyProtocolHelper.h"

@implementation ImageCaptureRoute

- (HTTPDataResponse*) generateGenericSuccessResponse{
    NSData *browseData = [[FranklyProtocolHelper generateSuccessResponseWithoutResults] dataUsingEncoding:NSUTF8StringEncoding];
   	return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
}

- (NSString *) snapshotDir{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"frank_view_snapshots"];
}

- (NSString *) pathForSnapshotOfViewWithUID:(NSString *)uid{
    NSString *filename = [uid stringByAppendingString:@".png"];
    return [[self snapshotDir] stringByAppendingPathComponent:filename];
}

#if TARGET_OS_IPHONE
- (void) snapshotView:(UIView *)view{
    UIImage *image = [view captureImage];
    NSData *imgData = UIImagePNGRepresentation(image);

    NSString *viewUID = [NSString stringWithFormat:@"%i",(int)view];
    [imgData writeToFile:[self pathForSnapshotOfViewWithUID:viewUID] atomically:NO];
}
#else
- (void) snapshotView:(NSView *)view{
    NSImage *image = [view captureImage];
    NSData *imgData = [[[image representations] objectAtIndex:0] representationUsingType:NSPNGFileType properties:nil];
    
    NSString *viewUID = [NSString stringWithFormat:@"%lu",(uintptr_t)view];
    [imgData writeToFile:[self pathForSnapshotOfViewWithUID:viewUID] atomically:NO];
}
#endif

- (void) snapshotViewAndSubviews:(id)view{
    [self snapshotView:view];
    for (id subview in [view subviews]){
        [self snapshotViewAndSubviews:subview];
    }    
}

- (void) prepSnapshotDir{
    [[NSFileManager defaultManager] removeItemAtPath:[self snapshotDir] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[self snapshotDir] withIntermediateDirectories:YES attributes:nil error:nil];
}
    
- (void) snapshotAllViews{
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    
    [self prepSnapshotDir];
    
#if TARGET_OS_IPHONE
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        [self snapshotViewAndSubviews:window];
    }
#else
    for (NSWindow *window in [[NSApplication sharedApplication] windows]) {
        [self snapshotViewAndSubviews: [window contentView]];
    }
#endif
    
    CFAbsoluteTime delta = CFAbsoluteTimeGetCurrent() - before;
    NSLog( @"snapshotted views to %@ in %f seconds", [self snapshotDir], delta );
}

- (HTTPFileResponse *)responseWithSnapshotOfViewWithUid:(NSString *)uid withConnection:(RoutingHTTPConnection *)connection {
    NSString *snapshotImagePath = [self pathForSnapshotOfViewWithUID:uid];
    if( [[NSFileManager defaultManager] fileExistsAtPath:snapshotImagePath] )
        return [[HTTPFileResponse alloc] initWithFilePath:snapshotImagePath forConnection:connection];
   	else
   		return nil;
}

- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection{
    
    if( ![@"screenshot" isEqualToString:[path objectAtIndex:0]] )
        return nil;


    if ( [path count] > 1 && [@"snapshot-all-views" isEqualToString:[path objectAtIndex:1]] ){
        [self snapshotAllViews];
        return [self generateGenericSuccessResponse];
    }

    if ( [path count] > 1 && [@"view-snapshot" isEqualToString:[path objectAtIndex:1]] ){
        return [self responseWithSnapshotOfViewWithUid:[path objectAtIndex:2] withConnection:connection];
    }

    BOOL allWindows = [path count] > 1 && [[path objectAtIndex:1] isEqualToString:@"allwindows"];
    
#if TARGET_OS_IPHONE
    UIImage *screenshot = [UIImage imageFromApplication:allWindows];
#else
    NSImage *screenshot = [NSImage imageFromApplication:allWindows];
#endif
    
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
    
#if TARGET_OS_IPHONE
    NSData *response = UIImagePNGRepresentation(screenshot);
#else
    NSData *response = [[[screenshot representations] objectAtIndex:0] representationUsingType:NSPNGFileType properties:nil];
#endif
    
    return [[[HTTPDataResponse alloc] initWithData:response] autorelease];
}

- (BOOL) canHandlePostForPath: (NSArray *)path{
    	return NO;
}

@end
