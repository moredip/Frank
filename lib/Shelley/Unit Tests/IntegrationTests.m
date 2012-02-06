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

- (void) testDescendantReturnsAllDescendantsPlusSelf_ForBackwardsCompatibilityWithUIQuery {
    Shelley *shelley = [Shelley withSelectorString:@"descendant"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)8, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:view];
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

- (void) testFirstSelectsFirstViewInMatchSet {
    UIView *rootView = [[[UIView alloc] init] autorelease];
    UIButton *firstButton = [[[UIButton alloc] init] autorelease];
    [rootView addSubview:[[[UIView alloc] init] autorelease]];
    [rootView addSubview:firstButton];
    [rootView addSubview:[[[UIButton alloc] init] autorelease]];
    [rootView addSubview:[[[UIView alloc] init] autorelease]];
    
    Shelley *shelley = [Shelley withSelectorString:@"button first"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:firstButton];
}

- (void) testFirstReturnsAnEmptyArrayWhenThereAreNoViewsInMatchSet {
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'I DO NOT EXIST' first"];
    NSArray *selectedViews = [shelley selectFrom:view];
    STAssertEquals((NSUInteger)0, selectedViews.count, nil);
}



- (void) testIndexSelectsNthViewInMatchSet {
    Shelley *shelley = [Shelley withSelectorString:@"button index:1"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewB];

}

- (void) testSelectsOnlyViewsWhichAreHidden {
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
    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"flap"] autorelease];
    UIViewWithAccessibilityLabel *subviewC = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:nil] autorelease];
    UIViewWithAccessibilityLabel *subviewD = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"brap"] autorelease];
    
    [rootView addSubview:subviewA];
    [rootView addSubview:subviewB];
    [rootView addSubview:subviewC];
    [rootView addSubview:subviewD];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'brap'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subviewA];
    [self assertArray:selectedViews containsObject:subviewD];
}

- (void) testMarkedSelectedSubstringMatchesWhileMarkedExactlyOnlySelectsExactMatches {
    UIView *rootView = [[[UIView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subviewA = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"Frankly"] autorelease];
    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"rank"] autorelease];
    UIViewWithAccessibilityLabel *subviewC = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"Fr-anky"] autorelease];
    UIViewWithAccessibilityLabel *subviewD = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:nil] autorelease];
    UIViewWithAccessibilityLabel *subviewE = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@" rank"] autorelease];

    [rootView addSubview:subviewA];
    [rootView addSubview:subviewB];
    [rootView addSubview:subviewC];
    [rootView addSubview:subviewD];
    [rootView addSubview:subviewE];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'rank'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)3, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subviewA];
    [self assertArray:selectedViews containsObject:subviewB];
    [self assertArray:selectedViews containsObject:subviewE];

    shelley = [Shelley withSelectorString:@"view markedExactly:'rank'"];
    selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subviewB];
}

- (void) testHandlesDoubleQuotedstringsWithSingleQuotesAndSpacesInside {
    UIView *rootView = [[[UIView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subview = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"I'm selected"] autorelease];
    [rootView addSubview:subview];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:\"I'm selected\""];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subview];
}

- (void) testHandlesSingleQuotesWithDoubleQuotesInside {
    UIView *rootView = [[[UIView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subview = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"say \"hi\" now"] autorelease];
    [rootView addSubview:subview];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'say \"hi\" now'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subview];
}

- (void) testAppliesFiltersSequentiallyInADepthFirstManner {
    UIView *rootView = [[[UIView alloc] init]autorelease];

    UIButton *buttonA = [[[UIButton alloc] init] autorelease];
    UIButton *buttonAA = [[[UIButton alloc] init] autorelease];
    UIView *nonButtonB = [[[UIView alloc] init]autorelease];
    UIButton *buttonBA = [[[UIButton alloc] init] autorelease];
    
    [rootView addSubview:buttonA];
    [buttonA addSubview:buttonAA];
    [rootView addSubview:nonButtonB];
    [nonButtonB addSubview:buttonBA];
    
    Shelley *shelley = [Shelley withSelectorString:@"button button"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    // The only button whose parent is a button is button AA
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:buttonAA];
}

- (void) testWeFilterOutDupes {
    Shelley *shelley = [Shelley withSelectorString:@"button parent descendant button"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewAA];
    [self assertArray:selectedViews containsObject:viewB];
}

- (void) testAllowsSelectionOfSiblingsAndCousinsViaParentFilter {
    UITableView *tableView = [[[UITableView alloc] init]autorelease];
    
    UITableViewCell *cellA = [[[UITableViewCell alloc] init] autorelease];
    UIViewWithAccessibilityLabel *subviewA = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"cell A"] autorelease];
    UIButton *buttonA = [[[UIButton alloc] init]autorelease];    
    [cellA addSubview:subviewA];
    [cellA addSubview:buttonA];

    UITableViewCell *cellB = [[[UITableViewCell alloc] init] autorelease];
    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"cell B"] autorelease];
    UIButton *buttonB = [[[UIButton alloc] init]autorelease];    
    [cellB addSubview:subviewB];
    [cellB addSubview:buttonB];
    
    [tableView addSubview:cellA];
    [tableView addSubview:cellB];
    
    NSArray *selectedViews = [[Shelley withSelectorString:@"view marked:'cell B'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewB]];

    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObjects:cellB,tableView,nil]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableViewCell'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:cellB]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableViewCell' button"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:buttonB]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableView'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:tableView]];    

    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableView' view marked:'cell A'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewA]];    
}

@end
