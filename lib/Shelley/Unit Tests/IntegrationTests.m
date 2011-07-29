//
//  IntegrationTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "IntegrationTests.h"
#import "Shelley.h"

#import "UIViewWithAccessibilityLabel.h"

@implementation IntegrationTests

- (void) setUp{
    view = [[[UIView alloc] init] autorelease];
    viewA = [[[UIView alloc] init] autorelease];
    viewAA = [[[UIButton alloc] init] autorelease];
    viewAB = [[[UIView alloc] init] autorelease];
    viewABA = [[[UIView alloc] init] autorelease];
    viewB = [[[UIButton alloc] init] autorelease];
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
    [self assertArray:selectedViews containsObject:viewB];
    [self assertArray:selectedViews containsObject:viewBA];
    [self assertArray:selectedViews containsObject:viewC];
}

- (void) testButtonReturnsAllDescendantsWhichAreButtons {
    Shelley *shelley = [Shelley withSelectorString:@"button"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewAA];
    [self assertArray:selectedViews containsObject:viewB];
}

-(void) testViewButtonReturnsAllGrandChildrenWhichAreButtons {
    Shelley *shelley = [Shelley withSelectorString:@"view button"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewAA];
}

-(void) testButtonParentReturnsTheRootView {
    UIView *rootView = [[[UIView alloc] init] autorelease];
    [rootView addSubview:[[[UIButton alloc] init] autorelease]];
    
    Shelley *shelley = [Shelley withSelectorString:@"button parent"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:rootView];
}

- (void) testMarkedSelectsOnlyViewsWhichAreHidden {
    [viewA setHidden:YES];
    [viewABA setHidden:YES];
    [viewBA setHidden:YES];
    
    Shelley *shelley = [Shelley withSelectorString:@"view isHidden"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)3, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewA];
    [self assertArray:selectedViews containsObject:viewABA];
    [self assertArray:selectedViews containsObject:viewBA];

}

- (void) testMarkedSelectsOnlyViewsWithMatchingAccessibilityLabel {
    UIView *rootView = [[[UIView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subviewA = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"brap"] autorelease];
    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"not brap"] autorelease];
    UIViewWithAccessibilityLabel *subviewC = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"brap"] autorelease];
    
    [rootView addSubview:subviewA];
    [rootView addSubview:subviewB];
    [rootView addSubview:subviewC];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'brap'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subviewA];
    [self assertArray:selectedViews containsObject:subviewC];
}

//- (void) testWeFilterOutDupes e.g. parent pivot on ancestors would have a lot of dupes

@end
