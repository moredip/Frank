//
//  UIScrollView+FrankScrolling.h
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FrankScrolling)

- (void) scrollToTop;
- (void) setContentOffsetX: (NSInteger) x y: (NSInteger) y;

@end