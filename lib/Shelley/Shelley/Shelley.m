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

- (id)initWithSelectorString:(NSString *)selectorString {
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

- (void) removeDuplicatesFromArray:(NSMutableArray *)mutableArray{
    NSArray *copy = [mutableArray copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([mutableArray indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [mutableArray removeObjectAtIndex:index];
        }
        index--;
    }
    [copy release];
}

- (NSArray *) applyFilter:(id<SYFilter>)filter toViews:(NSArray *)views{
    NSMutableArray *filteredViews = [NSMutableArray array];
    for (UIView *view in views) {
        [filteredViews addObjectsFromArray:[filter applyToView:view]];
    }
    [self removeDuplicatesFromArray:filteredViews];
    
    return filteredViews;
}

- (NSArray *) selectFrom:(UIView *)rootView
{
    id<SYFilter> filter = [_parser nextFilter];
    if( !filter )
        return [NSArray array];
    
    NSArray *views = [filter applyToView:rootView];
    
    while(( filter = [_parser nextFilter] )){
        views = [self applyFilter:filter toViews:views];
    }
    
    return views;
}

@end
