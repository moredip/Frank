//
//  NSStatusBar+FrankAutomation.m
//  Frank
//
//  Created by Buckley on 11/9/13.
//
//

#import <objc/runtime.h>

#import "NSStatusBar+FrankAutomation.h"

static const NSString* FEX_StatusBarItemsKey = @"FEX_StatusBarItemsKey";

@implementation NSStatusBar (FrankAutomation)

- (NSArray*) FEX_children
{
    NSArray* children = objc_getAssociatedObject(self, FEX_StatusBarItemsKey);
    
    if (children == nil)
    {
        children = [NSArray array];
    }
    
    return children;
}

- (NSStatusItem*) FEX_statusItemWithLength: (CGFloat) length
{
    NSStatusItem* statusItem = [self FEX_statusItemWithLength: length];
    
    if (statusItem != nil)
    {
        NSMutableArray* children = objc_getAssociatedObject(self, FEX_StatusBarItemsKey);
        
        if (children == nil)
        {
            children = [NSMutableArray array];
            objc_setAssociatedObject(self, FEX_StatusBarItemsKey, children, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        [children addObject: statusItem];
    }
    
    return statusItem;
}

- (void) FEX_removeStatusItem: (NSStatusItem*) item
{
    NSMutableArray* children = objc_getAssociatedObject(self, FEX_StatusBarItemsKey);
    
    if (children != nil)
    {
        [children removeObject: item];
    }
}

+ (void) load
{
    Method originalStatusItemWithLength = class_getInstanceMethod(self, @selector(statusItemWithLength:));
    Method replacedStatusItemWithLength = class_getInstanceMethod(self, @selector(FEX_statusItemWithLength:));
    
    Method originalRemoveStatusItem = class_getInstanceMethod(self, @selector(removeStatusItem:));
    Method replacedRemoveStatusItem = class_getInstanceMethod(self, @selector(FEX_removeStatusItem:));
    
    if (originalStatusItemWithLength != NULL &&
        replacedStatusItemWithLength != NULL &&
        originalRemoveStatusItem     != NULL &&
        replacedRemoveStatusItem     != NULL)
    {
        method_exchangeImplementations(originalStatusItemWithLength, replacedStatusItemWithLength);
        method_exchangeImplementations(originalRemoveStatusItem,     replacedRemoveStatusItem);
    }
}

@end
