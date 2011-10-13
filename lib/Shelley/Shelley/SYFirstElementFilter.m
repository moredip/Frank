//
//  SYFirstElementFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 8/25/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYFirstElementFilter.h"


@implementation SYFirstElementFilter

- (NSArray *)applyToViews:(NSArray *)views {
    return [NSArray arrayWithObject:[views objectAtIndex:0]];
}

- (void)setDoNotDescend:(BOOL)doNotDescend {
    // ignored
}

- (BOOL) nextFilterShouldNotDescend {
    return NO;
}

@end
