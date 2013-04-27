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

@interface FrankMenuTracker : NSObject
@property (nonatomic, readwrite, retain) NSMutableSet* menus;
@end

@implementation FrankMenuTracker

- (void) applicationDidBecomeActive: (NSNotification*) aNotification
{
    
}

+ (void) load
{
    [[NSNotificationCenter defaultCenter] addObserver: [self class]
                                             selector: @selector(applicationDidBecomeActive:)
                                                 name: NSApplicationDidFinishLaunchingNotification 
                                               object: nil];
}

- (void) menuOpened: (NSNotification*) aNotification
{
    if (![[aNotification object] isEqual: [NSApp mainMenu]])
    {
        [[self menus] addObject: [aNotification object]];
    }
}

- (void) menuClosed: (NSNotification*) aNotification
{
    [[self menus] removeObject: [aNotification object]];
}

- (id) init
{
    if (self = [super init])
    {
        _menus = [NSMutableSet new];
        
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

@implementation NSApplication (FrankAutomation)

- (void) FEX_startTrackingMenus
{
    FrankMenuTracker* menuTracker = [FrankMenuTracker new];
    objc_setAssociatedObject(self, FEX_MenuTrackerKey, menuTracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSSet*) FEX_menus
{
    FrankMenuTracker* menuTracker = objc_getAssociatedObject(self, FEX_MenuTrackerKey);
    return [menuTracker menus];
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

@end
