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
    
    // force call to delegate, in case implementors rely on this behavior
    if([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: self];
    }
}

- (void) setContentOffsetX: (NSInteger) x
                         y: (NSInteger) y {
    CGPoint point = CGPointMake(x, y);
    [self setContentOffset: point animated: NO];
    
    // force call to delegate, in case implementors rely on this behavior
    if([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: self];
    }
}

@end


@implementation UITableView (FrankScrolling)

- (void) scrollToRow: (NSInteger) row inSection: (NSInteger) section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: section];
    [self scrollToRowAtIndexPath: indexPath
                atScrollPosition: UITableViewScrollPositionNone
                        animated: NO];
    
    // force call to delegate, in case implementors rely on this behavior
    if([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: self];
    }
}

@end