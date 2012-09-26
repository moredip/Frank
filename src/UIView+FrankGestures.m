//
//  UIView+FrankGestures.m
//  Frank
//
//  Created by Pete Hodgson on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(UIView_FrankGestures)

#import <CoreGraphics/CoreGraphics.h>

#import "UIView-KIFAdditions.h"

#define NUM_POINTS_IN_SWIPE_PATH (20)
#define BIG_DELTA (200)
#define SMALL_DELTA (5)

@implementation UIView (FrankGestures)

CGSize swipeDeltasForDirection(NSString *direction, int pixels){
    NSString *dir = [direction lowercaseString];

    if([dir isEqualToString:@"left"]){
        return CGSizeMake(-pixels, SMALL_DELTA);
    }else if([dir isEqualToString:@"right"]){
        return CGSizeMake(pixels, SMALL_DELTA);
    }else if([dir isEqualToString:@"up"]){
        return CGSizeMake(SMALL_DELTA, -pixels);
    }else if([dir isEqualToString:@"down"]){
        return CGSizeMake(SMALL_DELTA, pixels);
    }else{
        [NSException raise:@"invalid swipe direction" format:@"swipe direction '%@' is invalid", direction];
        return CGSizeZero;
    }
}

-(void)swipeInDirection:(NSString *)dir {
    [self swipeInDirection:dir by:BIG_DELTA];
}

-(void)swipeInDirection:(NSString *)dir by:(int)pixels {
    CGPoint centerOfView = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    CGPoint swipeStart = centerOfView;
    
    CGSize delta = swipeDeltasForDirection(dir, pixels);
    
    CGPoint swipePath[NUM_POINTS_IN_SWIPE_PATH];
    for( int i = 0; i < NUM_POINTS_IN_SWIPE_PATH; i++ ){
        CGFloat progress = ((CGFloat)i)/NUM_POINTS_IN_SWIPE_PATH;
        swipePath[i] = CGPointMake( swipeStart.x +
                                   (delta.width*progress), swipeStart.y+(delta.height*progress));
    }
    
    [self dragAlongPathWithPoints:swipePath count:NUM_POINTS_IN_SWIPE_PATH];
}

@end