//
//  UIScrollView+FrankScrolling.h
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FrankScrolling)

- (void) frank_scrollToTop;
- (void) frank_scrollToBottom;
- (void) frank_setContentOffsetX: (NSInteger) x y: (NSInteger) y;

@end

@interface UITableView (FrankScrolling)

- (void) frank_scrollToRow: (NSInteger) row inSection: (NSInteger) section;

@end