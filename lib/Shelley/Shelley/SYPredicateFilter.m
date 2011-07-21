//
//  SYPredicateFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 7/20/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYPredicateFilter.h"

@implementation SYPredicateFilter
@synthesize selector=_selector,args=_args;

- (id)initWithSelector:(SEL)selector args:(NSArray *)args {
    self = [super init];
    if (self) {
        _selector = selector;
        _args = [args copy];
    }
    return self;
}
- (void)dealloc {
    [_args release];
    [super dealloc];
}

@end
