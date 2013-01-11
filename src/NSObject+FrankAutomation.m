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
            [self accessibilityAttributeValue: NSAccessibilityPositionAttribute];
        }
        
        if ([[self accessibilityAttributeNames] containsObject: NSAccessibilitySizeAttribute])
        {
            [self accessibilityAttributeValue: NSAccessibilitySizeAttribute];
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

@end
