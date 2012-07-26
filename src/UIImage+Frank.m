//
//  UIImage+Frank.m
//  Frank
//
//  Created by Brian King on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Frank.h"

#import "UIView+ImageCapture.h"


@implementation UIImage(Frank)

+ (UIImage *) imageFromApplication:(BOOL)allWindows 
{	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	
    if (allWindows)
        return [UIView captureImageOfSize:keyWindow.bounds.size fromViews:[[UIApplication sharedApplication] windows]];
    else
        return [keyWindow captureImage];
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
