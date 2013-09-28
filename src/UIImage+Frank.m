//
//  UIImage+Frank.m
//  Frank
//
//  Created by Brian King on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Frank.h"
#import <QuartzCore/QuartzCore.h>

#import "UIApplication+FrankAutomation.h"
#import "UIView+ImageCapture.h"

@implementation UIImage(Frank)

+ (UIImage *)imageFromApplication:(BOOL)allWindows resultInPortrait:(BOOL)resultInPortrait {
    UIApplication *application = [UIApplication sharedApplication];
    NSArray* windows = (allWindows) ? [application FEX_windows] : [NSArray arrayWithObject:application.keyWindow];
    
    UIInterfaceOrientation currentOrientation = application.statusBarOrientation;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    if (!resultInPortrait && UIInterfaceOrientationIsLandscape(currentOrientation)) {
        size = CGSizeMake(size.height, size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (!resultInPortrait) {
        if (currentOrientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextTranslateCTM(context, size.width / 2.0f, size.height / 2.0f);
            CGContextRotateCTM(context, (CGFloat) M_PI_2);
            CGContextTranslateCTM(context, - size.height / 2.0f, - size.width / 2.0f);
        }
        else if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
            CGContextTranslateCTM(context, size.width / 2.0f, size.height / 2.0f);
            CGContextRotateCTM(context, (CGFloat) -M_PI_2);
            CGContextTranslateCTM(context, - size.height / 2.0f, - size.width / 2.0f);
        }
        else if (currentOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextTranslateCTM(context, size.width / 2.0f, size.height / 2.0f);
            CGContextRotateCTM(context, (CGFloat) M_PI);
            CGContextTranslateCTM(context, -size.width / 2.0f, -size.height / 2.0f);
        }
    }
        
    for (UIView *window in windows) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context,
                              - window.bounds.size.width * window.layer.anchorPoint.x,
                              - window.bounds.size.height * window.layer.anchorPoint.y);
        
        [window.layer.presentationLayer renderInContext:UIGraphicsGetCurrentContext()];
        
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageCropedToFrame:(CGRect)cropFrame {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropFrame);
    UIImage *result = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)imageMaskedAtFrame:(CGRect)maskFrame {
    CGRect imageFrame = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:imageFrame];
    
    [[UIColor blackColor] set];
    UIRectFill(maskFrame);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
