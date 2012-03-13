//
//  UITableView+Frank.m
//  Frank
//
//  Created by Olivier Larivain on 3/9/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import "UITableView+Frank.h"

@interface UITableView(FrankPrivate)

- (NSArray *) rowIndexPathList;

@end

@implementation UITableView (Frank)

- (void) scrollBy: (int) numberOfRows {

    // get the last visible index path
	NSArray *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	NSIndexPath *indexPathForLastVisibleRow = [indexPathsForVisibleRows lastObject];
    
    // get the full list of indices
    NSArray *rowIndexPathList = [self rowIndexPathList];
    
    // and compute the wanted index in the flat list of indices
	int indexOfLastVisibleRow = [rowIndexPathList indexOfObject:indexPathForLastVisibleRow];
	int scrollToIndex = indexOfLastVisibleRow + numberOfRows;
    
    // and make sure stay within the bounds
	if (scrollToIndex >= rowIndexPathList.count) {
		scrollToIndex = rowIndexPathList.count - 1;
	}
    if( scrollToIndex < 0) {
        scrollToIndex = 0;
    }
    
	NSIndexPath *scrollToIndexPath = [rowIndexPathList objectAtIndex:scrollToIndex];
	[self scrollToRowAtIndexPath: scrollToIndexPath 
                atScrollPosition: UITableViewScrollPositionBottom 
                        animated: YES];
}

- (NSArray *) rowIndexPathList {

	NSMutableArray *rowIndexPathList = [NSMutableArray array];

	for(int i=0; i< [self numberOfSections]; i++) {
		for(int j=0; j< [self numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
			[rowIndexPathList addObject: indexPath];
		}
	}
    
	return rowIndexPathList;
}


@end
