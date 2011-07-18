//
//  IntegrationTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "IntegrationTests.h"
#import "Shelley.h"


@implementation IntegrationTests

- (void) testViewReturnsAllSubviews {
    UIView *someView = [[[UIView alloc] init] autorelease];
    [someView addSubview:[[[UIView alloc] init] autorelease]];
    [someView addSubview:[[[UIView alloc] init] autorelease]];
    [someView addSubview:[[[UIView alloc] init] autorelease]];
    
    Shelley *shelley = [Shelley withSelectorString:@"view"];
    
    NSArray *selectedViews = [shelley selectFrom:someView];
    
    STAssertEquals(selectedViews.count, someView.subviews.count, nil);
    for (int i = 0; i < selectedViews.count; i++) {
        STAssertEquals([selectedViews objectAtIndex:i], [someView.subviews objectAtIndex:i], nil);
    }
}

- (void) testViewReturnsAllDescendants {
    UIView *view = [[[UIView alloc] init] autorelease];
    UIView *viewA = [[[UIView alloc] init] autorelease];
    UIView *viewAA = [[[UIView alloc] init] autorelease];
    UIView *viewAB = [[[UIView alloc] init] autorelease];
    UIView *viewABA = [[[UIView alloc] init] autorelease];
    UIView *viewB = [[[UIView alloc] init] autorelease];
    UIView *viewBA = [[[UIView alloc] init] autorelease];
    UIView *viewC = [[[UIView alloc] init] autorelease];
    
    [view addSubview:viewA];
    [viewA addSubview:viewAA];
    [viewA addSubview:viewAB];
    [viewAB addSubview:viewABA];

    [view addSubview:viewB]; 
    [viewB addSubview:viewBA];
    
    [view addSubview:viewC];
    
    Shelley *shelley = [Shelley withSelectorString:@"view"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    //STAssertEquals((NSUInteger)7, selectedViews.count, nil);
}

@end
