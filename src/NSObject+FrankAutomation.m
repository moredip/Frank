//
//  NSObject+FrankAutomation.m
//  Frank
//
//  Created by Buckley on 12/5/12.
//
//

#import <objc/runtime.h>

#import <Foundation/Foundation.h>

#import "LoadableCategory.h"
MAKE_CATEGORIES_LOADABLE(NSObject_FrankAutomation)

#if TARGET_OS_IPHONE

@implementation NSObject (FrankAutomation)

- (NSString *) FEX_accessibilityLabel
{
    NSString* returnValue = nil;
    
    if ([self respondsToSelector: @selector(accessibilityLabel)])
    {
        returnValue = [self accessibilityLabel];
    }
    
    return returnValue;
}

- (CGRect) FEX_accessibilityFrame
{
    CGRect returnValue = CGRectZero;
    
    if ([self respondsToSelector: @selector(accessibilityFrame)])
    {
        returnValue = [self accessibilityFrame];
    }
    
    return returnValue;
}

@end

#else

#import "NSApplication+FrankAutomation.h"

static const NSString* FEX_AccessibilityDescriptionAttribute = @"FEX_AccessibilityDescriptionAttribute";

@implementation NSObject (FrankAutomation)

+ (void) load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(accessibilitySetOverrideValue:forAttribute:)),
                                   class_getInstanceMethod(self, @selector(FEX_accessibilitySetOverrideValue:forAttribute:)));
}

- (BOOL) FEX_accessibilitySetOverrideValue: (id) value forAttribute: (NSString*) attribute
{
    if ([value isKindOfClass: [NSString class]] && [attribute isEqualToString: NSAccessibilityDescriptionAttribute])
    {
        objc_setAssociatedObject(self, FEX_AccessibilityDescriptionAttribute, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return [self FEX_accessibilitySetOverrideValue: value forAttribute: attribute];
}

- (NSString *) FEX_accessibilityLabel
{
    NSString* returnValue = objc_getAssociatedObject(self, FEX_AccessibilityDescriptionAttribute);
    
    if (returnValue == nil || [returnValue isEqualToString: @""])
    {
        if ([self respondsToSelector: @selector(accessibilityAttributeNames)] &&
            [self respondsToSelector: @selector(accessibilityAttributeValue:)])
        {
            NSArray *candidateAttributes = @[ NSAccessibilityDescriptionAttribute,
                                              NSAccessibilityTitleAttribute ];
            
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
    }
    
    return [[returnValue copy] autorelease];
}

- (CGRect) FEX_accessibilityFrame
{
    NSPoint origin = NSZeroPoint;
    NSSize  size   = NSZeroSize;
    
    NSValue *originValue = nil;
    NSValue *sizeValue   = nil;
    
    CGFloat screenHeight = 0.0;
    CGFloat flippedY     = 0.0;
    
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
    
    for (NSScreen* screen in [NSScreen screens])
    {
        NSRect screenFrame = [screen convertRectFromBacking: [screen frame]];
        screenHeight = MAX(screenHeight, screenFrame.origin.y + screenFrame.size.height);
    }
    
    flippedY = screenHeight - (origin.y + size.height);
    
    if (flippedY >= 0 && originValue != nil)
    {
        origin.y = flippedY;
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

- (BOOL) FEX_cancel
{
    return [self FEX_performAccessibilityAction: NSAccessibilityCancelAction];
}

- (BOOL) FEX_confirm
{
    return [self FEX_performAccessibilityAction: NSAccessibilityConfirmAction];
}

- (BOOL) FEX_decrement
{
    return [self FEX_performAccessibilityAction: NSAccessibilityDecrementAction];
}

- (BOOL) FEX_delete
{
    return [self FEX_performAccessibilityAction: NSAccessibilityDeleteAction];
}

- (BOOL) FEX_increment
{
    return [self FEX_performAccessibilityAction: NSAccessibilityIncrementAction];
}

- (BOOL) FEX_pick
{
    return [self FEX_performAccessibilityAction: NSAccessibilityPickAction];
}

- (BOOL) FEX_showMenu
{
    return [self FEX_performAccessibilityAction: NSAccessibilityShowMenuAction];
}

@end

@implementation NSControl (FrankAutomation)

- (NSString*) FEX_accessibilityLabel
{
    NSString* returnValue = [super FEX_accessibilityLabel];
    
    if (returnValue == nil || [returnValue isEqualToString: @""])
    {
        returnValue = [[self cell] FEX_accessibilityLabel];
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

@implementation NSMenuItem (FrankAutomation)

- (NSString*) FEX_accessibilityLabel
{
    NSString* returnValue = nil;
    
    if ([self isSeparatorItem])
    {
        returnValue = @"Separator";
    }
    else
    {
        [super FEX_accessibilityLabel];
        
        if (returnValue == nil)
        {
            returnValue = [self title];
        }
    }
    
    return returnValue;
}

- (CGRect) FEX_accessibilityFrame
{
    CGRect         returnValue = NSMakeRect(0, 0, 0, 0);
    NSDictionary*  menuDict    = nil;
    
    if ([[self menu] isEqual: [[NSApplication sharedApplication] mainMenu]])
    {
        
        AXUIElementRef app  = AXUIElementCreateApplication([[NSRunningApplication currentApplication] processIdentifier]);
        AXUIElementRef menu = NULL;
        
        AXUIElementCopyAttributeValue(app, kAXMenuBarAttribute, (CFTypeRef*) &menu);
        
        menuDict = FEX_DictionaryForAXMenu(menu);
    }
    else
    {
        NSValue* menuPointer = [NSValue valueWithPointer: [self menu]];
        menuDict = [[[NSApplication sharedApplication] FEX_axMenus] objectForKey: menuPointer];
    }
    
    if (menuDict != NULL)
    {
        returnValue = [[menuDict objectForKey: [self title]] rectValue];
    }
    
    return returnValue;
}

- (BOOL) FEX_simulateClick
{
    BOOL returnValue = NO;
    
    if ([self menu] != nil)
    {
        if ([self hasSubmenu])
        {
            returnValue = [super FEX_simulateClick];
        }
        else
        {
            NSInteger itemIndex = [[self menu] indexOfItem: self];
            
            if (itemIndex >= 0)
            {
                [[self menu] performActionForItemAtIndex: itemIndex];
                returnValue = YES;
            }
        }
    }
    
    return returnValue;
}

@end

@implementation NSView (FrankAutomation)

- (BOOL) FEX_raise
{
    return [[self window] FEX_raise];
}

- (BOOL) FEX_simulateClick
{
    BOOL returnValue = [super FEX_simulateClick];
    
    if (!returnValue)
    {
        returnValue = [[self window] makeFirstResponder: nil];
        
        if (returnValue)
        {
            [[self window] makeKeyWindow];
            returnValue = [[self window] makeFirstResponder: self];
        }
    }
    
    return returnValue;
}

- (BOOL) FEX_mouseDownX: (CGFloat) x y: (CGFloat) y
{
    BOOL returnValue = NO;
    
    CGPoint location = CGPointMake(x, y);
    
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseDown,
                                               location,
                                               kCGMouseButtonLeft);

    if (event != NULL)
    {
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        event = NULL;
        
        returnValue = YES;
    }
    
    return returnValue;
}

- (BOOL) FEX_dragToX: (CGFloat) x y: (CGFloat) y
{
    BOOL returnValue = NO;
    
    CGPoint location = CGPointMake(x, y);
    
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseDragged,
                                               location,
                                               kCGMouseButtonLeft);
    if (event != NULL)
    {            
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        event = NULL;
        
        returnValue = YES;
    }

    return returnValue;
}

- (BOOL) FEX_mouseUpX: (CGFloat) x y: (CGFloat) y
{
    BOOL returnValue = NO;
    
    CGPoint location = CGPointMake(x, y);
    
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseUp,
                                               location,
                                               kCGMouseButtonLeft);
    if (event != NULL)
    {            
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        event = NULL;
        
        returnValue = YES;
    }
    
    return returnValue;
}
 
/*#define DRAG_DELAY 3.0
#define DRAG_STEPS 100

- (BOOL) FEX_dragWithInitialDelayToX: (CGFloat) x y: (CGFloat) y
{
    BOOL returnValue = YES;
    
    NSRect   frame    = [self FEX_accessibilityFrame];
    CGPoint  start    = CGPointMake(NSMidX(frame), NSMidY(frame));
    CGPoint  end      = CGPointMake(x, y);
    CGPoint  current  = start;
    CGFloat  deltaX   = (end.x - start.x) / DRAG_STEPS;
    CGFloat  deltaY   = (end.y - start.y) / DRAG_STEPS;
    CGFloat  timeStep = DRAG_DELAY / DRAG_STEPS;
    
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseDown,
                                               start,
                                               kCGMouseButtonLeft);
    
    if (event != NULL)
    {
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);
        event = NULL;
        
        //[[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: DRAG_DELAY]];
        
        CFRunLoopRunInMode((CFStringRef) NSEventTrackingRunLoopMode, DRAG_DELAY, false);
    }
    else
    {
        returnValue = NO;
    }
    
    for (int step = 0; returnValue && step < DRAG_STEPS; ++step)
    {
        current.x += deltaX;
        current.y += deltaY;
        event = CGEventCreateMouseEvent(NULL,
                                        kCGEventLeftMouseDragged,
                                        current,
                                        kCGMouseButtonLeft);
        
        if (event != NULL)
        {
            CGEventPost(kCGHIDEventTap, event);
            CFRelease(event);
            event = NULL;
            
            
            CFRunLoopRunInMode((CFStringRef) NSEventTrackingRunLoopMode, timeStep, false);
        }
        else
        {
            returnValue = NO;
        }
    }
    
    if (returnValue)
    {        
        CFRunLoopRunInMode((CFStringRef) NSEventTrackingRunLoopMode, DRAG_DELAY, false);
        
        event = CGEventCreateMouseEvent(NULL,
                                        kCGEventLeftMouseUp,
                                        end,
                                        kCGMouseButtonLeft);
        
        if (event != NULL)
        {
            CGEventPost(kCGHIDEventTap, event);
            CFRelease(event);
            event = NULL;
        }
        else
        {
            returnValue = NO;
        }
    }
    
    return returnValue;
}*/

@end

#endif
