//
//  FEXTableRow.m
//  Frank
//
//  Created by Buckley on 7/15/13.
//
//

#import "FEXTableRow.h"

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
    
    CGFloat screenHeight = 0;
    
    for (NSScreen* screen in [NSScreen screens])
    {
        NSRect screenFrame = [screen convertRectFromBacking: [screen frame]];
        screenHeight = MAX(screenHeight, screenFrame.origin.y + screenFrame.size.height);
    }
    
    CGFloat flippedY = screenHeight - (accessibilityFrame.origin.y + accessibilityFrame.size.height);
    
    if (flippedY >= 0)
    {
        accessibilityFrame.origin.y = flippedY;
    }
    
    return accessibilityFrame;
}

- (NSTableView*) table
{
    return _table;
}

@end
