//
//  NSImage+Frank.m
//  Frank
//
//  Created by Michael Buckley on 11/4/12.
//
//

#import "NSImage+Frank.h"
#import "NSView+FrankImageCapture.h"

@interface NSApplication ()
- (CGRect) FEX_accessibilityFrame;
@end

@implementation NSImage (Frank)

+ (NSImage *) imageFromApplication
{
    NSRect screenFrame = (NSRect) [[NSApplication sharedApplication] FEX_accessibilityFrame];
    
    NSImage* screenshot = [[[NSImage alloc] initWithSize: screenFrame.size] autorelease];
    
    NSMutableDictionary* appWindows        = [NSMutableDictionary dictionary];
    NSMutableArray*      screenshotWindows = [NSMutableArray array];
    
    for (NSWindow* window in [[NSApplication sharedApplication] windows])
    {
        [appWindows setObject: window forKey: [NSNumber numberWithInteger: [window windowNumber]]];
    }
    
    NSArray* allWindows = (NSArray*) CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
    
    for (NSDictionary* windowInfo in allWindows)
    {
        NSNumber* windowNumber = [windowInfo objectForKey: (NSString*) kCGWindowNumber];
        
        if ([appWindows objectForKey: windowNumber] != nil)
        {
            [screenshotWindows addObject: [appWindows objectForKey: windowNumber]];
        }
    }
    
    [allWindows release];
    
    [screenshot lockFocus];
        
    for (NSScreen* screen in [NSScreen screens])
    {
        NSRect frame = [screen frame];
        
        NSURL* backgroundURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen: screen];
        NSData* data = [NSData dataWithContentsOfURL: backgroundURL];
        NSImage* background = [[NSImage  alloc] initWithData: data];
        
        [screenshot lockFocus];
        
        [background drawInRect: frame
                      fromRect: NSZeroRect
                     operation: NSCompositeSourceOver
                      fraction: 1.0];
        
        [screenshot unlockFocus];
        
        [background release];
    }
    
    for (NSWindow* window in [screenshotWindows reverseObjectEnumerator])
    {
        NSInteger windowNumber = [window windowNumber];
        CGImageRef cgImage = CGWindowListCreateImage(CGRectNull,
                                                     kCGWindowListOptionIncludingWindow,
                                                     (CGWindowID) windowNumber,
                                                     kCGWindowImageDefault);
        
        NSImage* nsImage = [[NSImage alloc] initWithCGImage: cgImage size: [window frame].size];
        
        [screenshot lockFocus];
        
        [nsImage drawInRect: [window frame]
                   fromRect: NSZeroRect
                  operation: NSCompositeSourceOver
                   fraction: 1.0];
        
        [screenshot unlockFocus];
        
        [nsImage release];
        CFRelease(cgImage);
    }
        
    return  screenshot;
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
