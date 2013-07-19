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
}

- (id) initWithFrame: (NSRect) frame table: (NSTableView*) table;

- (NSTableView*) table;

@end
