//
//  UIScrollView+FrankScrolling.m
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//

#import "UIScrollView+FrankScrolling.h"

@implementation UIScrollView (FrankScrolling)

- (void) scrollToTop {
    [self setContentOffset: CGPointZero];
}

- (void) setContentOffsetX: (NSInteger) x
                         y: (NSInteger) y {
    CGPoint point = CGPointMake(x, y);
    [self setContentOffset: point animated: NO];
}

@end
