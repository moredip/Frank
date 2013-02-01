//
//  NSObject+FrankAutomation.m
//  Frank
//
//  Created by Buckley on 12/5/12.
//
//

#import <Foundation/Foundation.h>

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(NSObject_FrankAutomation)

@implementation NSObject (FrankAutomation)

- (NSString *) FEX_accessibilityLabel {
    NSString* returnValue = nil;
    
    if ([self respondsToSelector: @selector(accessibilityAttributeNames)] &&
        [self respondsToSelector: @selector(accessibilityAttributeValue:)])
    {
        NSArray *candidateAttributes = @[ NSAccessibilityDescriptionAttribute,
                                          NSAccessibilityTitleAttribute,
                                          NSAccessibilityValueAttribute ];
        
        for (NSString *candidateAttribute in candidateAttributes)
        {
            if ([[self accessibilityAttributeNames] containsObject: candidateAttribute])
            {
                id value = [self accessibilityAttributeValue: candidateAttribute];
                                
                if ([value isKindOfClass: [NSString class]]) {
                    returnValue = value;
                    break;
                }
            }
        }
    }
    
    return [[returnValue copy] autorelease];
}

- (CGRect) FEX_accessibilityFrame {
    NSPoint origin = NSZeroPoint;
    NSSize  size   = NSZeroSize;
    
    NSValue *originValue = nil;
    NSValue *sizeValue   = nil;
    
    if ([self respondsToSelector: @selector(accessibilityAttributeNames)] &&
        [self respondsToSelector: @selector(accessibilityAttributeValue:)])
    {
        if ([[self accessibilityAttributeNames] containsObject: NSAccessibilityPositionAttribute])
        {
            originValue = [self accessibilityAttributeValue: NSAccessibilityPositionAttribute];
        }
        
        if ([[self accessibilityAttributeNames] containsObject: NSAccessibilitySizeAttribute])
        {
            sizeValue = [self accessibilityAttributeValue: NSAccessibilitySizeAttribute];
        }
    }
    
    if (originValue != nil) {
        origin = [originValue pointValue];
    }
    
    if (sizeValue != nil)
    {
        size = [sizeValue sizeValue];
    }
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (BOOL) FEX_performAccessibilityAction: (NSString*) anAction
{
    BOOL returnValue = NO;
    
    if ([[self accessibilityActionNames] containsObject: anAction])
    {
        [self accessibilityPerformAction: anAction];
        returnValue = YES;
    }
    
    return returnValue;
}

- (BOOL) FEX_simulateClick
{
    return [self FEX_performAccessibilityAction: NSAccessibilityPressAction];
}

- (BOOL) FEX_raise
{
    return [self FEX_performAccessibilityAction: NSAccessibilityRaiseAction];
}

@end

@implementation NSApplication (FrankAutomation)

- (BOOL) FEX_raise
{
    [self activateIgnoringOtherApps: YES];
    return YES;
}

@end

@implementation NSControl (FrankAutomation)

- (NSString*) FEX_accessibilityLabel
{
    NSString* returnValue = [[self cell] FEX_accessibilityLabel];
    
    if (returnValue == nil)
    {
        returnValue = [super FEX_accessibilityLabel];
    }
    
    return returnValue;
}

- (CGRect) FEX_accessibilityFrame
{
    CGRect returnValue = [[self cell] FEX_accessibilityFrame];
    
    if (NSEqualRects(returnValue, NSZeroRect))
    {
        returnValue = [super FEX_accessibilityFrame];
    }
    
    return returnValue;
}

- (BOOL) FEX_performAccessibilityAction: (NSString*) anAction
{
    BOOL returnValue = [[self cell] FEX_performAccessibilityAction: anAction];
    
    if (returnValue == NO)
    {
        returnValue = [super FEX_performAccessibilityAction: anAction];
    }
    
    return returnValue;
}

@end
