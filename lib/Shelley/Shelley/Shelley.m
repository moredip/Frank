//
//  Shelley.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "Shelley.h"


@implementation Shelley

+ (Shelley *) withSelectorString:(NSString *)selectorString
{
    return [[[self alloc] initWithSelectorString:selectorString] autorelease];
}

- (id)initWithSelectorString:selectorString {
    self = [super init];
    if (self) {
        _parser = [[SYParser alloc] initWithSelectorString:selectorString];
    }
    return self;
}

- (void)dealloc {
    [_parser release];
    [super dealloc];
}

- (NSArray *) selectFrom:(UIView *)rootView
{
    id<SYFilter> filter = [_parser nextFilter];
    if( !filter )
        return [NSArray array];
    
    NSArray *views = [filter applyToView:rootView];
    
    //TODO: apply subsequent filters
    return views;
}

@end
