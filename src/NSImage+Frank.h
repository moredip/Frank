//
//  NSImage+Frank.h
//  Frank
//
//  Created by Michael Buckley on 11/4/12.
//
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Frank)

+ (NSImage *)imageFromApplication:(BOOL)allWindows;
- (NSImage *)imageCropedToFrame:(CGRect)cropFrame;
- (NSImage *)imageMaskedAtFrame:(CGRect)maskFrame;

@end
