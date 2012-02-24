//
//  UIImage+Frank.m
//  Frank
//
//  Created by Brian King on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Frank.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIImage(Frank)

+ (UIImage *) imageFromApplication:(BOOL)allWindows 
{	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	
	UIGraphicsBeginImageContext(keyWindow.bounds.size);
    if (allWindows)
    {
        for (UIWindow *w in [[UIApplication sharedApplication] windows])
        {
            [w.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
    }
    else
    {
        [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();	
	return image;
}

- (UIImage *)imageCropedToFrame:(CGRect)cropFrame
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropFrame);
    UIImage *result = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)imageMaskedAtFrame:(CGRect)maskFrame
{
    CGRect imageFrame = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:imageFrame];
    
    [[UIColor blackColor] set];
    UIRectFill(maskFrame);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
