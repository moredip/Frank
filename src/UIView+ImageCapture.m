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

+ (UIImage *) captureImageOfSize:(CGSize)size fromViews:(NSArray *)views {
	UIGraphicsBeginImageContext(size);
    for (UIView *view in views) {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();	
	return image;    
}

- (UIImage *) captureImage{
    return [UIView captureImageOfSize:self.bounds.size fromViews:[NSArray arrayWithObject:self]];
}

@end
