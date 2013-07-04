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
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
