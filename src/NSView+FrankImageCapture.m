//
//  NSView+FrankImageCapture.m
//  Frank
//
//  Created by Michael Buckley on 11/13/12.
//
//

#import "NSView+FrankImageCapture.h"

@implementation NSView (FrankImageCapture)

+ (NSImage *) captureImageOfSize:(NSSize)size fromViews:(NSArray *)views {
    
    NSImage *image = [[[NSImage alloc] initWithSize:size] autorelease];
    
    for (NSView *view in views){
        [view lockFocus];
        NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect: [view bounds]] autorelease];
        [view unlockFocus];
        
        [image addRepresentation: rep];
    }
    
    return image;
}


- (NSImage *) captureImage{
    return [NSView captureImageOfSize:self.bounds.size fromViews:[NSArray arrayWithObject:self]];
}

@end
