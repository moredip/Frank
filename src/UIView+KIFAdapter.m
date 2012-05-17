//
//  UIView+KIFAdapter.m
//  Frank
//
//  Created by Pete Hodgson on 10/15/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "LoadableCategory.h"
#import "UIView-KIFAdditions.h"

MAKE_CATEGORIES_LOADABLE(UIView_KIFAdapter)

@implementation UIView(KIFAdapter)

- (BOOL) touchPointIfInsideWindow:(CGPoint)point{

    CGPoint pointInWindowCoords = [self.window convertPoint:point fromView:self];
    if( !CGRectContainsPoint(self.window.bounds, pointInWindowCoords) ){
        return NO;
    }

    // delegate to KIF
    [self tapAtPoint:point];
    return YES;
}

- (BOOL)touch{
    CGPoint centerPoint = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    return [self touchPointIfInsideWindow:centerPoint];
}

- (BOOL) touchx:(NSNumber *)x y:(NSNumber *)y {
    return [self touchPointIfInsideWindow:CGPointMake([x floatValue], [y floatValue])];
}

@end