//
//  UIView+UIAutomationBridge.m
//  Frank
//
//  Created by Pete Hodgson on 6/27/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "UIAutomation.h"

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(UIView_UIAutomationBridge)

CGPoint centerOfViewInWindowCoords(UIView *view){
    CGPoint centerPoint = CGPointMake(view.frame.size.width * 0.5f, view.frame.size.height * 0.5f);
    return [view.window convertPoint:centerPoint fromView:view];
}

UIASyntheticEvents *events(){
    return [NSClassFromString(@"UIASyntheticEvents") sharedEventGenerator];
}

@implementation UIView (UIAutomationBridge)

- (id) FUI_tap{
    CGPoint tapPoint = centerOfViewInWindowCoords(self);
    [events() sendTap:tapPoint];

    return [NSValue valueWithCGPoint:tapPoint];
}

#define SWIPE_DURATION (0.1)
CGSize swipeDeltasForDirection(NSString *direction); // defined in UIView+FrankGestures.m

- (NSString *) FUI_swipe:(NSString *)dir{
    CGPoint swipeStart = centerOfViewInWindowCoords(self);
    CGSize delta = swipeDeltasForDirection(dir);
    CGPoint swipeEnd = CGPointMake(swipeStart.x+delta.width, swipeStart.y+delta.height);
    
    NSString *swipeDescription = [NSString stringWithFormat:@"%@ => %@", NSStringFromCGPoint(swipeStart), NSStringFromCGPoint(swipeEnd)];
    
    [events() sendDragWithStartPoint:swipeStart endPoint:swipeEnd duration:SWIPE_DURATION];

    return swipeDescription;
}


- (id) automationElement{
    CGPoint centerPoint = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    CGPoint centerPointInWindowCoords = [self.window convertPoint:centerPoint fromView:self];
    
    UIAXElement *axEl = [UIAXElement uiaxElementAtPosition:centerPointInWindowCoords];
    
    // both of the following lock up. According to Eloy's notes they might not work when run from the foreground app??
    UIAElement *element = [UIAElement elementForUIAXElement:axEl];
    //UIAElement *element = [NSClassFromString(@"UIAElement") elementAtPosition:centerPointInWindowCoords];
    
    return element;
}


@end
