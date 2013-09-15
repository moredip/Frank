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
#import "UIApplication+FrankAutomation.h"
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

#if !TARGET_OS_IPHONE
- (NSString *) pathForTransparentPNG
{
    return [[self snapshotDir] stringByAppendingPathComponent: @"transparent.png"];
}
#endif

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
    
#if !TARGET_OS_IPHONE
    NSImage* image = [[NSImage alloc] initWithSize:NSMakeSize(1.0, 1.0)];
    
    [image lockFocus];
    [NSColor colorWithDeviceWhite:1.0 alpha:0.0];
    NSRectFill(NSMakeRect(0, 0, 1.0, 1.0));
    
    NSBitmapImageRep* bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, 1.0, 1.0)];
    [image unlockFocus];
    
    NSData* data = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
    
    [data writeToFile:[self pathForTransparentPNG] atomically:NO];
    
    [bitmapRep release];
    [image release];
    
#endif
}

- (void) snapshotAllViews{
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    
    [self prepSnapshotDir];
    
#if TARGET_OS_IPHONE
    for (UIWindow *window in [[UIApplication sharedApplication] FEX_windows]) {
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
#if TARGET_OS_IPHONE
   		return nil;
#else
    return [[HTTPFileResponse alloc] initWithFilePath:[self pathForTransparentPNG] forConnection:connection];
#endif
}

- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection{
    
    if (![@"screenshot" isEqualToString:[path objectAtIndex:0]]) {
        return nil;
    }
    
    NSString* pathComponent2 = ([path count] > 1) ? [path objectAtIndex:1] : nil;    

    if ([pathComponent2 isEqualToString:@"snapshot-all-views"]) {
        [self snapshotAllViews];
        return [self generateGenericSuccessResponse];
    }
    else if ([pathComponent2 isEqualToString:@"view-snapshot"]) {
        return [self responseWithSnapshotOfViewWithUid:[path objectAtIndex:2] withConnection:connection];
    }
    
#if TARGET_OS_IPHONE
    
    BOOL allWindows = ([pathComponent2 isEqualToString:@"allwindows"] || [pathComponent2 isEqualToString:@"allwindows-rotated"]);
    BOOL rotated = ([pathComponent2 isEqualToString:@"rotated"] || [pathComponent2 isEqualToString:@"allwindows-rotated"]);
    
    UIImage *screenshot = [UIImage imageFromApplication:allWindows
                                       resultInPortrait:!rotated];
#else
    NSImage *screenshot = [NSImage imageFromApplication];
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
    [screenshot lockFocus];
    NSSize size = [screenshot size];
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, size.width, size.height)];
    [screenshot unlockFocus];
    
    NSData *response = [rep representationUsingType:NSPNGFileType properties:nil];
    [rep release];
#endif
    
    return [[[HTTPDataResponse alloc] initWithData:response] autorelease];
}

- (BOOL) canHandlePostForPath: (NSArray *)path{
    	return NO;
}

@end
