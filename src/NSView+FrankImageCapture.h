//
//  NSView+FrankImageCapture.h
//  Frank
//
//  Created by Michael Buckley on 11/13/12.
//
//

#import <Cocoa/Cocoa.h>

@interface NSView (FrankImageCapture)

+ (NSImage *) captureImageOfSize:(CGSize)size fromViews:(NSArray *)views;
- (NSImage *) captureImage;

@end
