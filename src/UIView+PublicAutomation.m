//
//  UIView+PublicAutomation.m
//  Frank
//
//  Created by Pete Hodgson on 10/15/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "PublicAutomation/UIAutomationBridge.h"

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(UIView_PublicAutomation)

NSString *formatCGPointVal( NSValue *val ){
    CGPoint p = [val CGPointValue];
    return [NSString stringWithFormat:@"[%.2f,%.2f]", p.x, p.y];
}

@implementation UIView(PublicAutomation)

- (BOOL) touchPointIfInsideWindow:(CGPoint)point{
    CGPoint pointInWindowCoords = [self.window convertPoint:point fromView:self];
    if( !CGRectContainsPoint(self.window.bounds, pointInWindowCoords) ){
        return NO;
    }
    
    [UIAutomationBridge tapView:self atPoint:point];
    return YES;
}

- (BOOL)touch{
    CGPoint centerPoint = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    return [self touchPointIfInsideWindow:centerPoint];
}

- (BOOL) touchx:(NSNumber *)x y:(NSNumber *)y {
    return [self touchPointIfInsideWindow:CGPointMake([x floatValue], [y floatValue])];
}

-(NSString *)swipeInDirection:(NSString *)strDir {
    PADirection dir = [UIAutomationBridge parseDirection:strDir];
    NSArray *swipeExtremes = [UIAutomationBridge swipeView:self inDirection:dir];
    return [NSString stringWithFormat:@"%@ => %@", formatCGPointVal([swipeExtremes objectAtIndex:0]),formatCGPointVal([swipeExtremes objectAtIndex:1])];
}


@end