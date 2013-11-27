//
//  FEXTableCellWrapper.m
//  Frank
//
//  Created by Buckley on 7/14/13.
//
//

#import "FEXTableCell.h"
#import "FEXTableRow.h"
#import "NSScreen+Frank.h"

@implementation FEXTableCell

- (id) initWithFrame: (NSRect) frame row: (FEXTableRow*) row value: (id) value
{
    if (self = [super initWithFrame: frame])
    {
        _row   = row;
        _value = [value retain];
    }
    
    return self;
}

- (void) dealloc
{
    id object = _value;
    [object release];
    _value = nil;
    
    [super dealloc];
}

- (CGRect) FEX_accessibilityFrame
{
    CGRect accessibilityFrame = [[_row table] convertRect: _frame toView: nil];
    accessibilityFrame = [[[_row table] window] convertRectToScreen: accessibilityFrame];

    accessibilityFrame = [NSScreen FEX_flipCoordinates: accessibilityFrame];
    
    return accessibilityFrame;
}

- (NSString*) FEX_accessibilityLabel
{
    if ([_value isKindOfClass: [NSString class]])
    {
        return _value;
    }
    else if ([_value respondsToSelector: @selector(stringValue)])
    {
        return [_value stringValue];
    }
    else
    {
        return @"";
    }
}

- (NSArray*) FEX_children
{
    NSArray* children = nil;
    id value = [self value];
    
    if ([value isKindOfClass: [NSView class]])
    {
        children = [NSArray arrayWithObject: value];
    }
    
    return children;
}

- (id) FEX_parent
{
    return _row;
}

- (id) value
{
    return _value;
}

- (BOOL) FEX_simulateClick
{
    return [_row FEX_simulateClick];
}

- (BOOL) FEX_isExpanded
{
    return [_row FEX_isExpanded];
}

- (BOOL) FEX_expand
{
    return [_row FEX_expand];
}

- (BOOL) FEX_collapse
{
    return [_row FEX_collapse];
}

@end
