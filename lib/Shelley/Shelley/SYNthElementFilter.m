//
//  SYNthElementFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 8/25/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYNthElementFilter.h"


@implementation SYNthElementFilter
@synthesize index=_index;

- (id)initWithIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _index = index;
    }
    return self;
}

- (NSArray *)applyToViews:(NSArray *)views {
    if( [views count] > _index )
        return [NSArray arrayWithObject:[views objectAtIndex:_index]];
    else
        return [NSArray array];
}

- (void)setDoNotDescend:(BOOL)doNotDescend {
    // ignored
}

- (BOOL) nextFilterShouldNotDescend {
    return NO;
}

@end
