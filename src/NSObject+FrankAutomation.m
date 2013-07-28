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

#if !TARGET_OS_IPHONE
#import "FEXTableRow.h"
#import "FEXTableCell.h"
#import "NSScreen+Frank.h"
#endif

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
static const NSString* FEX_ParentAttribute = @"FEX_ParentAttribute";

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

- (void) FEX_setParent: (id) aParent
{
    objc_setAssociatedObject(self, FEX_ParentAttribute, aParent, OBJC_ASSOCIATION_ASSIGN);
}

- (id) FEX_parent
{
    return objc_getAssociatedObject(self, FEX_ParentAttribute);
}

- (CGRect) FEX_accessibilityFrame
{
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
    
    CGRect accessibilityFrame = CGRectMake(origin.x, origin.y, size.width, size.height);
    
    accessibilityFrame = [NSScreen FEX_flipCoordinates: accessibilityFrame];
    
    return accessibilityFrame;
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

- (BOOL) FEX_isVisible
{
    return YES;
}

- (BOOL) FEX_isFullyVisible
{
    return YES;
}

@end

@implementation NSWindow(FrankAutomation)

- (CGRect) FEX_accessibilityFrame
{
    CGRect returnValue = NSZeroRect;
    
    if ([self isVisible] && ![self isMiniaturized])
    {
        returnValue = [super FEX_accessibilityFrame];
    }
    
    return returnValue;
}

- (BOOL) FEX_isVisible
{
    return [self isVisible];
}

- (BOOL) FEX_isFullyVisible
{
    return [[self contentView] FEX_isFullyVisible];
}

- (NSArray*) FEX_children
{
    return [NSArray arrayWithObject:[self contentView]];
}

- (id) FEX_parent
{
    return NSApp;
}

@end

@implementation NSControl (FrankAutomation)

- (NSString*) FEX_accessibilityLabel
{
    NSString* returnValue = [super FEX_accessibilityLabel];
    
    if (returnValue == nil || [returnValue isEqualToString: @""])
    {
        returnValue = [[self cell] FEX_accessibilityLabel];
        
        if (returnValue == nil || [returnValue isEqualToString: @""])
        {
            returnValue = [[self cell] title];
        }
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

@implementation NSMenu (FrankAutomation)

- (NSArray*) FEX_children
{
    return [self itemArray];
}

- (id) FEX_parent
{
    return NSApp;
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
        returnValue = [super FEX_accessibilityLabel];
        
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

- (NSArray*) FEX_children
{
    NSMutableArray *children = [NSMutableArray array];
    
    NSMenu *submenu = [self submenu];
    
    if (submenu != nil) {
        [children addObject:submenu];
    }
    
    return children;
}

- (id) FEX_parent
{
    id parent = [self parentItem];
    
    if (parent == nil)
    {
        parent = NSApp;
    }
    
    return parent;
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

- (CGRect) FEX_accessibilityFrame
{
    CGRect returnValue = [super FEX_accessibilityFrame];
    CGRect visibleRect = [self visibleRect];
    
    returnValue.size.width = visibleRect.size.width;
    returnValue.size.height = visibleRect.size.height;
    
    return returnValue;
}

- (NSArray*) FEX_children
{
    NSArray* subviews = [[self subviews] mutableCopy];
    NSMutableArray* children = [NSMutableArray array];
    
    for (NSView* subview in subviews)
    {
        CGRect frame = [subview FEX_accessibilityFrame];
        
        if (frame.size.width > 0 && frame.size.height > 0)
        {
            [children addObject: subview];
        }
    }
    
    return children;
}

- (id) FEX_parent
{
    id parent = [super FEX_parent];
    
    if (parent == nil)
    {
        parent = [self superview];
    }
    
    if (parent == nil)
    {
        parent = [self window];
    }
    
    return parent;
}

- (BOOL) FEX_isExpanded
{
    return [[self superview] FEX_isExpanded];
}

- (BOOL) FEX_expand
{
    return [[self superview] FEX_expand];
}

- (BOOL) FEX_collapse
{
    return [[self superview] FEX_collapse];
}

- (BOOL) FEX_isVisible
{
    if ([self isHidden])
    {
        return NO;
    }
    
    if ([self superview] != nil)
    {
        return [[self superview] FEX_isVisible];
    }
    else
    {
        return YES;
    }
}

- (BOOL) FEX_isFullyVisible
{
    if (![self FEX_isVisible])
    {
        return NO;
    }
    
    CGRect frame       = [self frame];
    CGRect visibleRect = [self visibleRect];
    
    return NSEqualSizes(frame.size, visibleRect.size);
}

@end

@implementation NSScrollView (FrankAutomation)

- (void) FEX_scrollToTop
{
    [[self contentView] scrollToPoint: CGPointZero];
}

- (void) FEX_scrollToBottom
{
    CGPoint maxContentOffset = CGPointZero;
    maxContentOffset.y = [self contentSize].height - [self frame].size.height;
    
    [[self contentView] scrollToPoint: maxContentOffset];
}


- (void) FEX_setContentOffsetX: (NSInteger) x
                             y: (NSInteger) y
{
    [[self contentView] scrollToPoint: CGPointMake(x, y)];
}

@end

static const NSString* FEX_TableAttribute = @"FEX_TableAttribute";
static const NSString* FEX_IndexAttribute = @"FEX_IndexAttribute";


@implementation NSTableRowView (FrankAutomation)

- (void) FEX_setTable: (NSTableView*) table
{
    objc_setAssociatedObject(self, FEX_TableAttribute, table, OBJC_ASSOCIATION_ASSIGN);
}

- (void) FEX_setIndex: (NSUInteger) index
{
    objc_setAssociatedObject(self, FEX_IndexAttribute, [NSNumber numberWithInteger: index], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL) FEX_isExpanded
{
    BOOL returnValue = NO;
    
    NSTableView* table = objc_getAssociatedObject(self, FEX_TableAttribute);
    
    if ([table isKindOfClass: [NSOutlineView class]])
    {
        NSUInteger index = [objc_getAssociatedObject(self, FEX_IndexAttribute) integerValue];
        
        id item = [(NSOutlineView*) table itemAtRow: index];
        returnValue = [(NSOutlineView*) table isItemExpanded: item];
    }
    
    return returnValue;
}

- (BOOL) FEX_expand
{
    BOOL returnValue = NO;
    
    NSTableView* table = objc_getAssociatedObject(self, FEX_TableAttribute);
    
    if ([table isKindOfClass: [NSOutlineView class]])
    {
        NSUInteger index = [objc_getAssociatedObject(self, FEX_IndexAttribute) integerValue];
        returnValue = YES;
        
        id item = [(NSOutlineView*) table itemAtRow: index];
        if (![(NSOutlineView*) table isItemExpanded: item])
        {
            [(NSOutlineView*) table expandItem: item];
        }
    }
    
    return returnValue;
}

- (BOOL) FEX_collapse
{
    BOOL returnValue = NO;
    
    NSTableView* table = objc_getAssociatedObject(self, FEX_TableAttribute);
    
    if ([table isKindOfClass: [NSOutlineView class]])
    {
        NSUInteger index = [objc_getAssociatedObject(self, FEX_IndexAttribute) integerValue];
        returnValue = YES;
        
        id item = [(NSOutlineView*) table itemAtRow: index];
        if ([(NSOutlineView*) table isItemExpanded: item])
        {
            [(NSOutlineView*) table collapseItem: item];
        }
    }
    
    return returnValue;
}

@end

@implementation NSTableView (FrankAutomation)

- (NSArray*) FEX_children
{
    NSMutableArray* children = [NSMutableArray array];
    
    if ([self headerView] != nil)
    {
        for (NSTableColumn* column in [self tableColumns])
        {
            CGRect frame = [column FEX_accessibilityFrame];
            
            if (frame.size.width > 0 && frame.size.height > 0)
            {
                [children addObject: column];
            }
        }
    }
    
    CGRect visibleRect = [self visibleRect];
    NSRange rowRange = [self rowsInRect: visibleRect];
    
    for (NSUInteger rowNum = rowRange.location; rowNum < rowRange.length; ++rowNum)
    {
        CGRect rowRect = [self rectOfRow: rowNum];
        rowRect = NSIntersectionRect(rowRect, visibleRect);
        
        FEXTableRow* row = [[[FEXTableRow alloc] initWithFrame: rowRect
                                                         table: self
                                                         index: rowNum] autorelease];
        
        for (NSUInteger colNum = 0; colNum < [self numberOfColumns]; ++colNum)
        {
            CGRect objectFrame = [self frameOfCellAtColumn: colNum row: rowNum];
            objectFrame = NSIntersectionRect(objectFrame, visibleRect);
            
            id cellValue = [self viewAtColumn: colNum
                                                           row: rowNum
                                               makeIfNecessary: NO];
            
            if (cellValue != nil)
            {
                if (colNum == 0)
                {
                    [(NSTableRowView*) [cellValue superview] FEX_setTable: self];
                    [(NSTableRowView*) [cellValue superview] FEX_setIndex: rowNum];
                    
                    [children addObject: [cellValue superview]];
                }
            }
            else
            {
                // We need to wrap the NSTableView cell in an object to
                // be accessible to Frank.
                
                id<NSTableViewDataSource> dataSource = [self dataSource];
                
                if (dataSource != nil)
                {
                    cellValue = [dataSource tableView: self
                            objectValueForTableColumn: colNum
                                                  row: rowNum];
                }
                else
                {
                    cellValue = [[self preparedCellAtColumn: colNum row: rowNum] objectValue];
                }
                
                if (cellValue != nil)
                {
                    FEXTableCell* cell = [[FEXTableCell alloc] initWithFrame: objectFrame
                                                                         row: row
                                                                       value: cellValue];
                    
                    if (objectFrame.size.width > 0 && objectFrame.size.height > 0)
                    {
                        [row addSubview: cell];
                    }
                    
                    [cell release];
                }
                
                if (row != nil && colNum == 0)
                {
                    [children addObject: row];
                }
            }
        }
    }
    
    return children;
}

- (void) FEX_scrollToRow: (NSInteger) row
               inSection: (NSInteger) section
{
    [self scrollRowToVisible: row];
}

@end

@implementation NSOutlineView (FrankAutomation)

- (NSArray*) FEX_children
{
    NSMutableArray* children = [NSMutableArray array];
    
    if ([self headerView] != nil)
    {
        for (NSTableColumn* column in [self tableColumns])
        {
            CGRect frame = [column FEX_accessibilityFrame];
            
            if (frame.size.width > 0 && frame.size.height > 0)
            {
                [children addObject: column];
            }
        }
    }
    
    CGRect visibleRect = [self visibleRect];
    NSRange rowRange = [self rowsInRect: visibleRect];
    id<NSOutlineViewDataSource> dataSource = [self dataSource];
    
    for (NSUInteger rowNum = rowRange.location; rowNum < rowRange.length; ++rowNum)
    {
        NSView* rowView = [self rowViewAtRow: rowNum makeIfNecessary: NO];
        
        if (rowView != nil)
        {
            [(NSTableRowView*) rowView FEX_setTable: self];
            [(NSTableRowView*) rowView FEX_setIndex: rowNum];
            [children addObject: rowView];
        }
        else
        {
            CGRect rowRect = [self rectOfRow: rowNum];
            rowRect = NSIntersectionRect(rowRect, visibleRect);
            
            FEXTableRow* row = [[[FEXTableRow alloc] initWithFrame: rowRect
                                                             table: self
                                                             index: rowNum] autorelease];
            
            id item = [self itemAtRow: rowNum];
            
            for (NSUInteger colNum = 0; colNum < [self numberOfColumns]; ++colNum)
            {
                id cellValue = nil;
                
                CGRect colRect = [self frameOfCellAtColumn: colNum row: rowNum];
                colRect = NSIntersectionRect(colRect, visibleRect);
                
                if (colRect.size.width > 0 && colRect.size.height > 0)
                {
                    if (dataSource != nil)
                    {
                    
                        cellValue = [dataSource outlineView: self
                                  objectValueForTableColumn: [[self tableColumns] objectAtIndex: colNum]
                                                     byItem: item];
                    }
                    else
                    {
                        cellValue = [[self preparedCellAtColumn: colNum row: rowNum] objectValue];
                    }
                }
                
                if (cellValue != nil)
                {
                    FEXTableCell* cell = [[FEXTableCell alloc] initWithFrame: colRect
                                                                         row: row
                                                                       value: cellValue];
                    
                    [row addSubview: cell];
                    [cell release];
                }
            }
            
            if (row != nil)
            {
                [children addObject: row];
            }
        }
    }
    
    return children;
}

@end

@implementation NSTableColumn (FrankAutomation)

- (NSString*) FEX_accessibilityLabel
{
    NSString* returnValue = [super FEX_accessibilityLabel];
    
    if (returnValue == nil || [returnValue isEqualToString: @""])
    {
        returnValue = [[self headerCell] FEX_accessibilityLabel];
        
        if (returnValue == nil || [returnValue isEqualToString: @""])
        {
            returnValue = [[self headerCell] stringValue];
        }
    }
    
    return returnValue;
}

- (CGRect) FEX_accessibilityFrame
{
    NSTableHeaderView* headerView = [[self tableView] headerView];
    CGRect enclosingFrame = [[[headerView tableView] enclosingScrollView] visibleRect];
    CGRect headerFrame = [headerView frame];
    NSUInteger colNum = [[[self tableView] tableColumns] indexOfObject: self];
    CGRect columnFrame = [[self tableView] rectOfColumn: colNum];
    
    headerFrame.origin.x = columnFrame.origin.x;
    headerFrame.size.width = columnFrame.size.width;
    
    headerFrame = NSIntersectionRect(headerFrame, enclosingFrame);
    
    CGRect accessibilityFrame = [headerView convertRect: headerFrame toView: nil];
    accessibilityFrame = [[headerView window] convertRectToScreen: accessibilityFrame];
    
    accessibilityFrame = [NSScreen FEX_flipCoordinates: accessibilityFrame];
    
    return accessibilityFrame;
}

@end

#endif
