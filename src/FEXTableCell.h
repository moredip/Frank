//
//  FEXTableCellWrapper.h
//  Frank
//
//  Created by Buckley on 7/14/13.
//
//

#import <Foundation/Foundation.h>

@class FEXTableRow;

@interface FEXTableCell : NSView
{
    FEXTableRow* _row;
    id _value;
}

- (id) initWithFrame: (NSRect) frame row: (FEXTableRow*) row value: (id) value;

- (id) value;

@end
