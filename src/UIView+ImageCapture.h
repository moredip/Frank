//
//  UIView+ImageCapture.h
//  Frank
//
//  Created by Pete Hodgson on 7/26/12.
//  Copyright (c) 2012 Thoughtworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ImageCapture)

+ (UIImage *) captureImageOfSize:(CGSize)size fromViews:(NSArray *)views;
- (UIImage *) captureImage;

@end
