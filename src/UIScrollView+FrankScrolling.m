//
//  UIScrollView+FrankScrolling.m
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//

#import "UIScrollView+FrankScrolling.h"

@implementation UIScrollView (FrankScrolling)

- (void) frank_scrollToTop {
    [self setContentOffset: CGPointZero];
    
    [self frank_forceDelegateCallOnScroll];
}

- (void) frank_scrollToBottom {
    CGPoint maxContentOffset = CGPointZero;
    maxContentOffset.y = self.contentSize.height - self.frame.size.height;
    [self setContentOffset: maxContentOffset];
    
    [self frank_forceDelegateCallOnScroll];
}


- (void) frank_setContentOffsetX: (NSInteger) x
                         y: (NSInteger) y {
    CGPoint point = CGPointMake(x, y);
    [self setContentOffset: point animated: NO];
    
    [self frank_forceDelegateCallOnScroll];
}

- (void) frank_forceDelegateCallOnScroll {
    // force call to delegate, in case implementors rely on this behavior
    if([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: self];
    }
}

@end


@implementation UITableView (FrankScrolling)

- (void) frank_scrollToRow: (NSInteger) row inSection: (NSInteger) section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: section];
    [self scrollToRowAtIndexPath: indexPath
                atScrollPosition: UITableViewScrollPositionNone
                        animated: NO];
    
    [self frank_forceDelegateCallOnScroll];
}

@end