//
//  UIScrollView+Frank.m
//  Frank
//
//  Created by Olivier Larivain on 3/9/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import "UIScrollView+Frank.h"

@interface UIScrollView(FrankPrivate)

- (CGFloat) maxContentOffset;

@end

@implementation UIScrollView (Frank)

- (void) scrollTo:(int)offset {
    // make sure we're in bounds
    CGFloat maxContentOffset = [self maxContentOffset];
    CGFloat contentOffset = MIN(offset, maxContentOffset);
    contentOffset = contentOffset < 0 ? 0 : contentOffset;
    
    // and scroll to point
    CGPoint point = CGPointMake(0, contentOffset);
	[self setContentOffset: point animated:NO];
}

- (void) scrollToBottom {
    CGPoint point = CGPointMake(0, [self maxContentOffset]);
	[self setContentOffset: point animated: YES];
}

- (void) scrollToTop {
    [self setContentOffset: CGPointZero];
}

- (void) scrollToNextPage {
//    // make sure we're in bounds
//    CGFloat maxContentOffset = [self maxContentOffset];
//    CGFloat contentOffset = MIN(offset, maxContentOffset);
//    contentOffset = contentOffset < 0 ? 0 : contentOffset;
//    
//    // and scroll to point
//    CGPoint point = CGPointMake(0, contentOffset);
//	[self setContentOffset: point animated:NO];
    NSLog(@"scrollToNextPage Not implemented...");

}

- (CGFloat) maxContentOffset {
    return self.contentSize.height - self.bounds.size.height;
}

@end
