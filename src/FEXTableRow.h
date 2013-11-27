//
//  FEXTableRow.h
//  Frank
//
//  Created by Buckley on 7/15/13.
//
//

#import <Cocoa/Cocoa.h>

@interface FEXTableRow : NSView
{
    NSTableView* _table;
    NSUInteger   _index;
}

- (id) initWithFrame: (NSRect) frame table: (NSTableView*) table index: (NSUInteger) index;

- (NSTableView*) table;

- (BOOL) FEX_simulateClick;
- (BOOL) FEX_isExpanded;
- (BOOL) FEX_expand;
- (BOOL) FEX_collapse;

@end
