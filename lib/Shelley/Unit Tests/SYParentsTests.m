//
//  SYParentsTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParentsTests.h"

#import "SYParents.h"


@implementation SYParentsTests


- (void)testReturnsAllAncestors {
    UIView *view = [[[UIView alloc] init] autorelease];
    UIView *viewA = [[[UIView alloc] init] autorelease];
    UIView *viewAA = [[[UIButton alloc] init] autorelease];
    UIView *viewAB = [[[UIView alloc] init] autorelease];
    UIView *viewABA = [[[UIView alloc] init] autorelease];
    UIView *viewB = [[[UIButton alloc] init] autorelease];
    UIView *viewBA = [[[UIView alloc] init] autorelease];
    UIView *viewC = [[[UIView alloc] init] autorelease];
    
    [view addSubview:viewA];
    [viewA addSubview:viewAA];
    [viewA addSubview:viewAB];
    [viewAB addSubview:viewABA];
    
    [view addSubview:viewB]; 
    [viewB addSubview:viewBA];
    
    [view addSubview:viewC];
    
    SYParents *filter = [[[SYParents alloc] init]autorelease];
    
    NSArray *filteredViews = [filter applyToView:viewABA];
    STAssertEquals((NSUInteger)3, [filteredViews count], nil);
    [self assertArray:filteredViews containsObject:viewAB];
    [self assertArray:filteredViews containsObject:viewA];
    [self assertArray:filteredViews containsObject:view];
}

@end
