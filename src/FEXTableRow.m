//
//  FEXTableRow.m
//  Frank
//
//  Created by Buckley on 7/15/13.
//
//

#import "FEXTableRow.h"
#import "NSScreen+Frank.h"

@implementation FEXTableRow

- (id) initWithFrame: (NSRect) frame table: (NSTableView*) table index: (NSUInteger) index
{
    self = [super initWithFrame: frame];
    if (self) {
        _table = table;
        _index = index;
    }
    
    return self;
}

- (id) FEX_parent
{
    return _table;
}

- (CGRect) FEX_accessibilityFrame
{
    CGRect accessibilityFrame = [_table convertRect: _frame toView: nil];
    accessibilityFrame = [[_table window] convertRectToScreen: accessibilityFrame];
    
    accessibilityFrame = [NSScreen FEX_flipCoordinates: accessibilityFrame];
    
    return accessibilityFrame;
}

- (NSTableView*) table
{
    return _table;
}

- (BOOL) FEX_simulateClick
{
    [_table selectRowIndexes: [NSIndexSet indexSetWithIndex: _index] byExtendingSelection: NO];
    return YES;
}

- (BOOL) FEX_isExpanded
{
    BOOL returnValue = NO;
    
    if ([_table isKindOfClass: [NSOutlineView class]])
    {
        id item = [(NSOutlineView*) _table itemAtRow: _index];
        returnValue = [(NSOutlineView*) _table isItemExpanded: item];
    }
    
    return returnValue;
}

- (BOOL) FEX_expand
{
    BOOL returnValue = NO;
    
    if ([_table isKindOfClass: [NSOutlineView class]])
    {
        returnValue = YES;
        
        id item = [(NSOutlineView*) _table itemAtRow: _index];
        if (![(NSOutlineView*) _table isItemExpanded: item])
        {
            [(NSOutlineView*) _table expandItem: item];
        }
    }
    
    return returnValue;
}

- (BOOL) FEX_collapse
{
    BOOL returnValue = NO;
    
    if ([_table isKindOfClass: [NSOutlineView class]])
    {
        returnValue = YES;
        
        id item = [(NSOutlineView*) _table itemAtRow: _index];
        if ([(NSOutlineView*) _table isItemExpanded: item])
        {
            [(NSOutlineView*) _table collapseItem: item];
        }
    }
    
    return returnValue;
}

@end
