//
// UISLider+PublicAutomation.m
//
// Created by Alvaro Barbeira on 27/3/13
//
#import <PublicAutomation/UIAutomationBridge.h>
#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(UISlider_PublicAutomation)

@implementation UISlider(PublicAutomation)

- (BOOL) FEX_dragThumbToValue:(double)value withDuration:(NSTimeInterval)interval {
    return [UIAutomationBridge dragThumbInSlider:self toValue:value withDuration:interval];
}

- (BOOL) FEX_dragThumbToValue:(double) value {
    return [UIAutomationBridge dragThumbInSlider:self toValue:value];
}
@end