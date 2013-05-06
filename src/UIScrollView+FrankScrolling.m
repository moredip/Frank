//
//  UIScrollView+FrankScrolling.m
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define DURATION_EPSILON (0.01)

@implementation UIScrollView (FrankScrolling)

- (BOOL) FEX_scrollToTop {
    return [self FEX_setContentOffsetX:self.contentOffset.x y:0.0f duration:0.0];
}

- (BOOL) FEX_scrollToBottom {
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    CGFloat maxContentOffsetY = self.contentSize.height - bounds.size.height;
    
    return [self FEX_setContentOffsetX:self.contentOffset.x y:maxContentOffsetY duration:0.0];
}

- (BOOL)FEX_setContentOffsetX:(NSInteger)x
                            y:(NSInteger)y {
    
    return [self FEX_setContentOffsetX:x y:y duration:0.0];
}

- (BOOL)FEX_scrollByRatioX:(CGFloat)ratioX
                         y:(CGFloat)ratioY
                  duration:(NSTimeInterval)duration {
    
    CGPoint offset;
    offset.x = self.contentOffset.x + ratioX * self.bounds.size.width;
    offset.y = self.contentOffset.y + ratioY * self.bounds.size.height;
    
    return [self FEX_setContentOffsetX:offset.x y:offset.y duration:duration];
}

- (CGPoint)FEX_boundedOffset:(CGPoint)offset {
    CGSize size = self.bounds.size;
    CGSize contentSize = self.contentSize;
    UIEdgeInsets insets = self.contentInset;
    
    CGPoint boundedOffset;
    boundedOffset.x = MIN(MAX(- insets.left, offset.x), contentSize.width - size.width + insets.right);
    boundedOffset.y = MIN(MAX(- insets.top, offset.y), contentSize.height - size.height + insets.bottom);

    return boundedOffset;
}

- (BOOL)FEX_setContentOffsetX:(CGFloat)x
                            y:(CGFloat)y
                     duration:(NSTimeInterval)duration {
    
    if (!self.scrollEnabled) {
        return NO;
    }
    
    CGPoint originalOffset = self.contentOffset;
    CGPoint offset;
    
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    
    CGPoint boundedPoint = [self FEX_boundedOffset:CGPointMake(x, y)];
    
    BOOL bouncesX = (self.bounces && (self.contentSize.width > bounds.size.width || self.alwaysBounceHorizontal));
    BOOL bouncesY = (self.bounces && (self.contentSize.height > bounds.size.height || self.alwaysBounceVertical));
    
    offset.x = (bouncesX) ? x : boundedPoint.x;
    offset.y = (bouncesY) ? y : boundedPoint.y;
    
    CGPoint velocity;
    
    if (duration > DURATION_EPSILON) {
        velocity.x = (offset.x - originalOffset.x) / duration;
        velocity.y = (offset.y - originalOffset.y) / duration;
    }
    else {
        velocity.x = (offset.x - originalOffset.x);
        velocity.y = (offset.y - originalOffset.y);
    }    
    
    void (^onCompletion)() = ^{
        if (!self.pagingEnabled && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
            
            CGPoint targetOffset = offset;
            [self.delegate scrollViewWillEndDragging:self withVelocity:velocity targetContentOffset:&targetOffset];
            [self setContentOffset:targetOffset animated:NO];
        }
        
        if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
            [self.delegate scrollViewDidEndDragging:self willDecelerate:NO];
        }
                
        if (bouncesX || bouncesY) {
            [self setContentOffset:[self FEX_boundedOffset:self.contentOffset] animated:YES];
        }
    };
    
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:self];
    }
    
    if (duration > DURATION_EPSILON) {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                            [self setContentOffset:offset animated:NO];
                         } completion:^(BOOL finished){
                             onCompletion();
                         }];
    }
    else {
        [self setContentOffset:offset animated:NO];
        onCompletion();
    }
    
    return YES;
}

@end

@implementation UITableView (FrankScrolling)

- (void) FEX_forceDelegateCallOnScroll {
    // force call to delegate, in case implementors rely on this behavior
    if([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: self];
    }
}

- (BOOL) FEX_scrollToRow: (NSInteger) row inSection: (NSInteger) section {
    return [self FEX_scrollToRow:row inSection:section duration:DURATION_EPSILON];
}

- (BOOL)FEX_scrollToRow:(NSInteger)row
              inSection:(NSInteger)section
               duration:(NSTimeInterval)duration {
    
    if (section < 0 || section >= [self numberOfSections]) {
        return NO;
    }
    else if (row < 0 || row >= [self numberOfRowsInSection:section]) {
        return NO;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];    
    
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    cellRect = CGRectOffset(cellRect, - self.contentOffset.x, - self.contentOffset.y);
    
    CGRect tableRect = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    
    if (CGRectContainsRect(tableRect, cellRect)) {
        return YES;
    }
        
    void (^onCompletion)() = ^{
        [self FEX_forceDelegateCallOnScroll];
    };
    
    if (duration > DURATION_EPSILON) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:onCompletion];
        [CATransaction setAnimationDuration:duration];
        
        [self scrollToRowAtIndexPath:indexPath
                    atScrollPosition:UITableViewScrollPositionNone
                            animated:YES];
        
        [CATransaction commit];
    }
    else {
        [self scrollToRowAtIndexPath:indexPath
                    atScrollPosition:UITableViewScrollPositionNone
                            animated:NO];

        onCompletion();
    }
    
    return YES;
}

@end