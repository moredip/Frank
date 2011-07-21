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

- (void) setUp{
    view = [[[UIView alloc] init] autorelease];
    viewA = [[[UIView alloc] init] autorelease];
    viewAA = [[[UIView alloc] init] autorelease];
    viewAB = [[[UIView alloc] init] autorelease];
    viewABA = [[[UIView alloc] init] autorelease];
    viewB = [[[UIView alloc] init] autorelease];
    viewBA = [[[UIView alloc] init] autorelease];
    viewC = [[[UIView alloc] init] autorelease];
    
    [view addSubview:viewA];
    [viewA addSubview:viewAA];
    [viewA addSubview:viewAB];
    [viewAB addSubview:viewABA];
    
    [view addSubview:viewB]; 
    [viewB addSubview:viewBA];
    
    [view addSubview:viewC];
}

- (void) assertArray:(NSArray *)array containsObject:(id)object{
    STAssertTrue( [array containsObject:object], nil );
}

- (void) assertArray:(NSArray *)array containsObjects:(NSArray *)objects{
    for (id obj in objects) {
        [self assertArray:array containsObject:obj];
    }
}

- (void) testViewReturnsAllSubviews {
    UIView *someView = [[[UIView alloc] init] autorelease];
    [someView addSubview:[[[UIView alloc] init] autorelease]];
    [someView addSubview:[[[UIView alloc] init] autorelease]];
    [someView addSubview:[[[UIView alloc] init] autorelease]];
    
    Shelley *shelley = [Shelley withSelectorString:@"view"];
    
    NSArray *selectedViews = [shelley selectFrom:someView];
    
    STAssertEquals(selectedViews.count, someView.subviews.count, nil);
    [self assertArray:selectedViews containsObjects:someView.subviews];
}

- (void) testViewReturnsAllDescendants {
    Shelley *shelley = [Shelley withSelectorString:@"view"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)7, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewA];
    [self assertArray:selectedViews containsObject:viewAA];
    [self assertArray:selectedViews containsObject:viewAB];
    [self assertArray:selectedViews containsObject:viewABA];
    [self assertArray:selectedViews containsObject:viewAB];
    [self assertArray:selectedViews containsObject:viewBA];
    [self assertArray:selectedViews containsObject:viewC];
}

- (void) xtestMarkedSelectsOnlyViewsWhichAreHidden {
    [viewA setHidden:YES];
    [viewABA setHidden:YES];
    [viewBA setHidden:YES];
    
    Shelley *shelley = [Shelley withSelectorString:@"view hidden"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)3, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewA];
    [self assertArray:selectedViews containsObject:viewABA];
    [self assertArray:selectedViews containsObject:viewBA];

}

- (void) xtestMarkedSelectsOnlyViewsWithMatchingAccessibilityLabel {
    [viewA setAccessibilityLabel:@"brap"];
    [viewABA setAccessibilityLabel:@"brap"];
    [viewBA setAccessibilityLabel: @"brap"];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'brap'"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)3, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewA];
    [self assertArray:selectedViews containsObject:viewABA];
    [self assertArray:selectedViews containsObject:viewBA];
}

//- (void) testWeFilterOutDupes e.g. parent pivot on ancestors would have a lot of dupes

@end
