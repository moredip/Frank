//
//  UIView+ImageCapture.m
//  Frank
//
//  Created by Pete Hodgson on 7/26/12.
//  Copyright (c) 2012 Thoughtworks. All rights reserved.
//

#import "UIView+ImageCapture.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ImageCapture)

- (UIImage *)captureImage {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = self.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
