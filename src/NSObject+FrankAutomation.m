//
//  NSObject+FrankAutomation.m
//  Frank
//
//  Created by Buckley on 12/5/12.
//
//

#import <Foundation/Foundation.h>

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(NSVObject_FrankAutomation)

@implementation NSObject (FrankAutomation)

- (NSString *) FEX_accessibilityLabel {
    NSString* returnValue = nil;
    
    NSArray *candidateAttributes = @[ NSAccessibilityDescriptionAttribute,
                                      NSAccessibilityTitleAttribute,
                                      NSAccessibilityValueAttribute ];
    
    for (NSString *candidteAttribute in candidateAttributes)
    {
        id value = [self accessibilityAttributeValue: candidteAttribute];
        
        if ([value isKindOfClass: [NSString class]]) {
            returnValue = value;
            break;
        }
    }
    
    return [[returnValue copy] autorelease];
}

- (CGRect) FEX_accessibilityFrame {
    NSPoint origin = NSZeroPoint;
    NSSize size   = NSZeroSize;
    
    NSValue *originValue = [self accessibilityAttributeValue: NSAccessibilityPositionAttribute];
    NSValue *sizeValue = [self accessibilityAttributeValue: NSAccessibilitySizeAttribute];
    
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
