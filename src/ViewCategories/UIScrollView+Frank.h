//
//  UIScrollView+Frank.h
//  Frank
//
//  Created by Olivier Larivain on 3/9/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Frank)

- (void) scrollTo: (int)offset;
- (void) scrollToTop;
- (void) scrollToBottom;
- (void) scrollToNextPage;

@end
