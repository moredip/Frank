//
//  UIView+PublicAutomation.m
//  Frank
//
//  Created by Pete Hodgson on 10/15/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import <PublicAutomation/UIAutomationBridge.h>

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(UIView_PublicAutomation)

NSString *formatCGPointVal( NSValue *val ){
    CGPoint p = [val CGPointValue];
    return [NSString stringWithFormat:@"[%.2f,%.2f]", p.x, p.y];
}

@implementation UIView(PublicAutomation)

- (BOOL)touchPointIfInsideWindow:(CGPoint)point {
    CGPoint pointInWindowCoords = [self.window convertPoint:point fromView:self];
    if (!CGRectContainsPoint(self.window.bounds, pointInWindowCoords)) {
        return NO;
    }
    
    [UIAutomationBridge tapView:self atPoint:point];
    return YES;
}

- (BOOL)touch {
    CGPoint centerPoint = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    return [self touchPointIfInsideWindow:centerPoint];
}

- (BOOL)touchx:(NSNumber *)x y:(NSNumber *)y {
	if (CGFLOAT_IS_DOUBLE) {
		return [self touchPointIfInsideWindow:CGPointMake([x doubleValue], [y doubleValue])];
	}
	
	return [self touchPointIfInsideWindow:CGPointMake([x floatValue], [y floatValue])];
}

//Modled on UIAutomation
#pragma mark - Touch Gestures

//Double Tap
- (BOOL)doubleTapPointIfInsideWindow:(CGPoint)point {
	CGPoint pointInWindowCoords = [self.window convertPoint:point fromView:self];
	if (!(CGRectContainsPoint(self.window.bounds, pointInWindowCoords))) {
		return NO;
	}
	
	[UIAutomationBridge doubleTapView:self atPoint:point];
	return YES;
}

- (BOOL)doubleTap {
	CGPoint centerPoint = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    return [self doubleTapPointIfInsideWindow:centerPoint];
}

- (BOOL)doubleTapx:(NSNumber *)x y:(NSNumber *)y {
	if (CGFLOAT_IS_DOUBLE)
	{
		return [self doubleTapPointIfInsideWindow:CGPointMake([x doubleValue], [y doubleValue])];
	}
	
	return [self doubleTapPointIfInsideWindow:CGPointMake([x floatValue], [y floatValue])];
}

////Tap With Options
//- (BOOL)tapWithOptions:(NSDictionary *)options pointIfInsideWindow:(CGPoint)point {
//	
//}
//
//- (BOOL)tapWithOptions:(NSDictionary *)options {
//	
//}
//
//- (BOOL)tapWithOptions:(NSDictionary *)options x:(NSNumber *)x y:(NSNumber *)y {
//	
//}

//Touch and hold
- (BOOL)touchAndHold:(NSTimeInterval)duration pointIfInsideWindow:(CGPoint)point {
	CGPoint pointInWindowCoords = [self.window convertPoint:point fromView:self];
	if (!(CGRectContainsPoint(self.window.bounds, pointInWindowCoords))) {
		return NO;
	}
	
	[UIAutomationBridge longTapView:self atPoint:point forDuration:duration];
	return YES;
}

- (BOOL)touchAndHold:(CGFloat)duration {
	CGPoint centerPoint = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    return [self touchAndHold:duration pointIfInsideWindow:centerPoint];
}

- (BOOL)touchAndHold:(CGFloat)duration x:(NSNumber *)x y:(NSNumber *)y {
	if (CGFLOAT_IS_DOUBLE)
	{
		return [self touchAndHold:duration pointIfInsideWindow:CGPointMake([x doubleValue], [y doubleValue])];
	}
	
	return [self touchAndHold:duration pointIfInsideWindow:CGPointMake([x floatValue], [y floatValue])];
}

////Two finger tap
//- (BOOL)twofingerTapPointIfInsideWindow:(CGPoint)point {
//	
//}
//
//- (BOOL)twofingerTap {
//	
//}
//
//- (BOOL)twofingerTapx:(NSNumber *)x y:(NSNumber *)y {
//	
//}

#pragma mark - Swipe Gestures
//TODO
//-(void)swipeInDirection:(NSString *)dir by:(int)pixels {


- (NSString *)swipeInDirection:(NSString *)strDir {
    PADirection dir = [UIAutomationBridge parseDirection:strDir];
    NSArray *swipeExtremes = [UIAutomationBridge swipeView:self inDirection:dir];
    return [NSString stringWithFormat:@"%@ => %@", formatCGPointVal([swipeExtremes objectAtIndex:0]),formatCGPointVal([swipeExtremes objectAtIndex:1])];
}

- (BOOL)FEX_dragWithInitialDelayToX:(CGFloat)x y:(CGFloat)y {
    [UIAutomationBridge dragViewWithInitialDelay:self toPoint:CGPointMake(x,y)];
    return YES;
}


@end