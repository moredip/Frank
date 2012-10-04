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


@implementation UITableView (FrankScrolling)

- (void) scrollToRow: (NSInteger) row inSection: (NSInteger) section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: section];
    [self scrollToRowAtIndexPath: indexPath
                atScrollPosition: UITableViewScrollPositionNone
                        animated: NO];
}

@end