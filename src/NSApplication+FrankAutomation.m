//
//  NSApplication+FrankAutomation.m
//  Frank
//
//  Created by Buckley on 12/5/12.
//
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#import "LoadableCategory.h"
#import "NSApplication+FrankAutomation.h"

MAKE_CATEGORIES_LOADABLE(NSApplication_FrankAutomation)

/* Working with menus through OS X's accessibility API is tricky. There are
 * three main issues with menus.
 *
 * First, closed menus return zero for their items' dimensions and coordinates.
 * In order to get the accessibilityFrame of a menu item, its menu must first be
 * opened. This applies to submenus as well.
 *
 * Second, NSMenuItem contains very little support for the NSAccessibility API.
 * It is not possible to get the dimensions or coordinates of an NSMenuItem
 * through the NSAccessibility API. Although NSMenuItem has a -view method, its
 * default return value is nil. This method is for implementing custom view-
 * based menu items. Normal NSMenuItems do not have underlying NSView objects,
 * nor do they have cells (NSMenuItemCell exists, but was changed in 10.5 to do
 * nothing).
 *
 * Third, contextual menus are not properly added to the view hierarchy.
 * These menus are not present in the view hierarchy at all except when open.
 * Although these menus contain references to their parent elements, the parent
 * elements have no knowledge of their menus. This is true in Cocoa, as well as
 * both of OS X's accessibility APIs.
 *
 * OS X actually contains 2 accessibility APIs. The Carbon Accessibility API,
 * and the NSAccessibility API. In general, NSAccessibility supports a subset of
 * the Carbon API. If NSAccessibility is not implemented on top of the Carbon
 * API, they most certainly share a common foundation.
 *
 * The Carbon Accessibility API has been moved to the HIServices framework
 * inside the ApplicationServices framework. It does not seem to be deprecated
 * along with most of the rest of Carbon.
 *
 * To work around these issues, we keep track of open menus in a couple of
 * associated objects we store on the shared NSApplication object.
 
 * The menus NSMutableSet keeps track of all contextual menus so that Frank can
 * get access to them. We append these menus to the view hierarchy in Shelley
 * and the dump command. In both these places, they are children of the
 * NSApplication object.
 *
 * The axMenus NSMutableDictionary keeps track of all open menus so that we get
 * a mapping from NSMenuItem to its accessibilityFrame. Its structure is
 * described below.
 *
 * The Carbon API works with pointers to opaque structures called
 * AXUIElementRefs. Unfortunately, there is no way to map from an NSObject to an
 * AXUIElementRef. So the axMenus dictionary stores as its keys NSValues
 * pointing to NSMenus. Although NSMenu implements NSCopying, and thus can be
 * used as a key for an NSDictionary, a copied NSMenu is not considered to be
 * equal to the original. Therefore, we store the pointer to the NSMenu as an
 * NSValue.
 *
 * The values of the axMenus dictionary are themselves dictionaries, mapping
 * menu items titles to their accessibilityFrames. This means that if a menu has
 * two or more items with the same title, only the last one will report its
 * accessibilityFrame. Fortunately, sharing titles between items in a menu is
 * unlikely to happen, and a sign of bad design when it does. There's also
 * nothing we can do to work around this restriction.
 *
 * The axMenus dictionary is filled in when we receive notices that a menu has
 * opened. We first get a notification from Cocoa, where we store the NSMenu
 * pointer. We then get a notification from the Carbon API with an
 * AXUIElementRef for the menu. We interrogate this AXUIElementRef for its
 * children's titles, positions, and dimensions, and combined with the stored
 * NSMenu pointer use them to fill out the axMenus dictionary.
 *
 * The Cocoa notification always arrives before the Carbon notification. This is
 * due to the fact that we add a CFRunLoopSource for the Carbon notification
 * after Cocoa has added its runloop sources. If the order of these
 * notifications ever changes, this code will need to be rewritten accordingly.
 */

@interface FrankMenuTracker : NSObject
@property (nonatomic, readwrite, retain) NSMutableSet*        menus;
@property (nonatomic, readwrite, retain) NSMutableDictionary* axMenus;
@end

static NSMenu* frankLastTrackedMenu = nil;

NSDictionary* FEX_DictionaryForAXMenu(AXUIElementRef menu)
{
    NSMutableDictionary* menuItems = [NSMutableDictionary dictionary];
    CFArrayRef           children    = NULL;
    CFIndex              numChildren = 0;
    
    AXUIElementGetAttributeValueCount(menu, kAXChildrenAttribute, &numChildren);
    
    if (numChildren > 0)
    {
        AXUIElementCopyAttributeValues(menu, kAXChildrenAttribute, 0, numChildren, &children);
    }
    
    for (CFIndex childIndex = 0; childIndex < numChildren; ++childIndex)
    {
        AXUIElementRef child = (AXUIElementRef) CFArrayGetValueAtIndex(children, childIndex);
        
        NSString*  title = nil;
        AXValueRef value = NULL;
        CGRect     frame = NSMakeRect(0, 0, 0, 0);
        
        AXUIElementCopyAttributeValue(child, kAXTitleAttribute,    (CFTypeRef*) &title);
        AXUIElementCopyAttributeValue(child, kAXPositionAttribute, (CFTypeRef*) &value);
        
        if (value != NULL)
        {
            AXValueGetValue(value, kAXValueCGPointType, &frame.origin);
        }
        
        AXUIElementCopyAttributeValue(child, kAXSizeAttribute, (CFTypeRef*) &value);
        
        if (value != NULL)
        {
            AXValueGetValue(value, kAXValueCGSizeType, &frame.size);
        }
        
        [menuItems setObject: [NSValue valueWithRect: frame] forKey: title];
    }
    
    return menuItems;
}

@implementation FrankMenuTracker

- (void) menuOpened: (NSNotification*) aNotification
{
    if (![[aNotification object] isEqual: [NSApp mainMenu]])
    {
        [[self menus] addObject: [aNotification object]];
    }
    
    frankLastTrackedMenu = (NSMenu*) [aNotification object];
}

- (void) menuClosed: (NSNotification*) aNotification
{
    [[self menus]   removeObject:       [aNotification object]];
    [[self axMenus] removeObjectForKey: [aNotification object]];
}

- (id) init
{
    if (self = [super init])
    {
        _menus   = [NSMutableSet        new];
        _axMenus = [NSMutableDictionary new];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(menuOpened:)
                                                     name: NSMenuDidBeginTrackingNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(menuClosed:)
                                                     name: NSMenuDidEndTrackingNotification
                                                   object: nil];
    }
    
    return self;
}

- (void) dealloc
{
    [_menus release];
    
    [super dealloc];
}

@end

static const NSString* FEX_MenuTrackerKey = @"FEX_MenuTrackerKey";

void MyAXObserverCallback(AXObserverRef  observer,
                          AXUIElementRef element,
                          CFStringRef    notificationName,
                          void*          contextData)
{
    NSValue* menuPointer = [NSValue valueWithPointer: frankLastTrackedMenu];    
    
    [[(FrankMenuTracker*) contextData axMenus] setObject: FEX_DictionaryForAXMenu(element) forKey: menuPointer];
}

@implementation NSApplication (FrankAutomation)

- (void) FEX_startTrackingMenus
{
    FrankMenuTracker* menuTracker = [FrankMenuTracker new];
    objc_setAssociatedObject(self, FEX_MenuTrackerKey, menuTracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    AXObserverRef observer = NULL;
    AXUIElementRef appRef = AXUIElementCreateApplication([[NSRunningApplication currentApplication] processIdentifier]);
    AXObserverCreate([[NSRunningApplication currentApplication] processIdentifier], MyAXObserverCallback, &observer);
    
    AXObserverAddNotification(observer, appRef, kAXMenuOpenedNotification, menuTracker);
    
    CFRunLoopSourceRef runloopSource = AXObserverGetRunLoopSource(observer);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runloopSource, kCFRunLoopCommonModes);
}

- (NSSet*) FEX_menus
{
    FrankMenuTracker* menuTracker = objc_getAssociatedObject(self, FEX_MenuTrackerKey);
    return [menuTracker menus];
}

- (NSDictionary*) FEX_axMenus
{
    FrankMenuTracker* menuTracker = objc_getAssociatedObject(self, FEX_MenuTrackerKey);
    return [menuTracker axMenus];
}

- (CGRect) FEX_accessibilityFrame {
    CGFloat maxWidth  = 0;
    CGFloat maxHeight = 0;
    
    for (NSScreen* screen in [NSScreen screens])
    {
        NSRect  frame  = [screen convertRectFromBacking: [screen frame]];
        CGFloat width  = frame.origin.x + frame.size.width;
        CGFloat height = frame.origin.y + frame.size.height;
        
        maxWidth  = MAX(width, maxWidth);
        maxHeight = MAX(height, maxHeight);
    }
    
    return CGRectMake(0, 0, maxWidth, maxHeight);
}

- (BOOL) FEX_raise
{
    [self activateIgnoringOtherApps: YES];
    return YES;
}

- (BOOL) FEX_isVisible
{
    return ![self isHidden];
}

- (BOOL) FEX_isFullyVisible
{
    return [self FEX_isVisible];
}

- (NSArray*) FEX_children
{    
    NSMutableArray *descendants = [NSMutableArray array];
    
    [descendants addObjectsFromArray:[self windows]];
    [descendants addObject:[self mainMenu]];
    [descendants addObjectsFromArray:[[self FEX_menus] allObjects]];
    
    return descendants;
}

- (id) FEX_parent
{
    return nil;
}

@end
