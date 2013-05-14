//
//  UIImage+Frank.h
//  Frank
//
//  Created by Brian King on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage(Frank)

+ (UIImage *)imageFromApplication:(BOOL)allWindows resultInPortrait:(BOOL)resultInPortrait;
- (UIImage *)imageCropedToFrame:(CGRect)cropFrame;
- (UIImage *)imageMaskedAtFrame:(CGRect)maskFrame;


@end
