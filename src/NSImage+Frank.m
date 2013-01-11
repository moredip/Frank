//
//  NSImage+Frank.m
//  Frank
//
//  Created by Michael Buckley on 11/4/12.
//
//

#import "NSImage+Frank.h"
#import "NSView+FrankImageCapture.h"

@implementation NSImage (Frank)

+ (NSImage *) imageFromApplication:(BOOL)allWindows
{
    NSWindow* mainWindow = [[NSApplication sharedApplication] mainWindow];
    
    if (allWindows){
        NSMutableArray *views = [NSMutableArray array];
        
        for (NSWindow *window in [[NSApplication sharedApplication] windows]){
            [views addObject:[window contentView]];
        }
        
        return [NSView captureImageOfSize:mainWindow.frame.size fromViews:views];
    }
    else{
        return [[mainWindow contentView] captureImage];
    }
}

- (NSImage *)imageCropedToFrame:(CGRect)cropFrame
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImageForProposedRect: NULL context: nil hints:nil], cropFrame);
    NSImage *result = [[NSImage alloc] initWithCGImage:imageRef size: NSZeroSize];
    CGImageRelease(imageRef);
    return [result autorelease];
}

- (NSImage *)imageMaskedAtFrame:(CGRect)maskFrame
{
    NSImage* result = [NSImage copy];
    [result lockFocus];
    
    [[NSColor blackColor] set];
    NSRectFill(maskFrame);
    
    [result unlockFocus];
    
    return result;
}

@end
