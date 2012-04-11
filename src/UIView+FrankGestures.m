//
//  UIView+FrankGestures.m
//  Frank
//
//  Created by Pete Hodgson on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+FrankGestures.h"
#import "UIView-KIFAdditions.h"

#define NUM_POINTS_IN_SWIPE_PATH (20)

@implementation UIView (FrankGestures)


-(void)swipeLeftwards {
    CGPoint centerOfView = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    CGPoint swipeStart = centerOfView;

    CGFloat x_delta = -150;
    CGFloat y_delta = 5; 
    CGPoint swipePath[NUM_POINTS_IN_SWIPE_PATH];
    for( int i = 0; i < NUM_POINTS_IN_SWIPE_PATH; i++ ){
        CGFloat progress = ((CGFloat)i)/NUM_POINTS_IN_SWIPE_PATH;
        swipePath[i] = CGPointMake( swipeStart.x + 
                                   (x_delta*progress), swipeStart.y+(y_delta*progress)); 
    }

    [self dragAlongPathWithPoints:swipePath count:NUM_POINTS_IN_SWIPE_PATH];
}

@end
