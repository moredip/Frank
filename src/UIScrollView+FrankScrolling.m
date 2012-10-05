//
//  UIScrollView+FrankScrolling.m
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//

@implementation UIScrollView (FrankScrolling)

- (void) FEX_scrollToTop {
    [self setContentOffset: CGPointZero];
    
    [self FEX_forceDelegateCallOnScroll];
}

- (void) FEX_scrollToBottom {
    CGPoint maxContentOffset = CGPointZero;
    maxContentOffset.y = self.contentSize.height - self.frame.size.height;
    [self setContentOffset: maxContentOffset];
    
    [self FEX_forceDelegateCallOnScroll];
}


- (void) FEX_setContentOffsetX: (NSInteger) x
                         y: (NSInteger) y {
    CGPoint point = CGPointMake(x, y);
    [self setContentOffset: point animated: NO];
    
    [self FEX_forceDelegateCallOnScroll];
}

- (void) FEX_forceDelegateCallOnScroll {
    // force call to delegate, in case implementors rely on this behavior
    if([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: self];
    }
}

@end


@implementation UITableView (FrankScrolling)

- (void) FEX_scrollToRow: (NSInteger) row inSection: (NSInteger) section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: section];
    [self scrollToRowAtIndexPath: indexPath
                atScrollPosition: UITableViewScrollPositionNone
                        animated: NO];
    
    [self FEX_forceDelegateCallOnScroll];
}

@end