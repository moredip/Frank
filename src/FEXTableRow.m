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

- (id) initWithFrame: (NSRect) frame table: (NSTableView*) table
{
    self = [super initWithFrame: frame];
    if (self) {
        _table = table;
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

@end
