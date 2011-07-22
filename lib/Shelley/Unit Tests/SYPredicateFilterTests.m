//
//  SYPredicateFilterTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYPredicateFilterTests.h"

#import "SYPredicateFilter.h"

@interface DummyView : UIView {
    BOOL methodWasCalled;
    BOOL returnValue;
}
@property BOOL methodWasCalled,returnValue;
@end

@implementation DummyView
@synthesize methodWasCalled,returnValue;

- (id)init {
    self = [super init];
    if (self) {
        methodWasCalled = NO;
    }
    return self;
}

- (BOOL) dummyMethod{
    methodWasCalled = YES;
    return returnValue;
}

@end


@implementation SYPredicateFilterTests

- (void) testGracefullyHandlesViewNotRespondingToSelector{
    UIView *view = [[[UIView alloc] init]autorelease];
    SYPredicateFilter *filter = [[[SYPredicateFilter alloc] initWithSelector:@selector(notPresent) args:[NSArray array]] autorelease];
    
    NSArray *filteredViews = [filter applyToView:view];
    STAssertNotNil(filteredViews, nil);
    STAssertEquals((NSUInteger)0, [filteredViews count], nil);
}

- (void) testCallsPredicateMethodOnView{
    DummyView *view = [[[DummyView alloc] init]autorelease];
    
    SYPredicateFilter *filter = [[[SYPredicateFilter alloc] initWithSelector:@selector(dummyMethod) args:[NSArray array]] autorelease];
    
    STAssertFalse([view methodWasCalled],nil);
    [filter applyToView:view];
    STAssertTrue([view methodWasCalled],nil);
}

- (void) testFiltersOutViewIfPredicateReturnsNO{
    DummyView *view = [[[DummyView alloc] init]autorelease];
    view.returnValue = NO;
    
    SYPredicateFilter *filter = [[[SYPredicateFilter alloc] initWithSelector:@selector(dummyMethod) args:[NSArray array]] autorelease];
    
    NSArray *filteredViews = [filter applyToView:view];
    STAssertNotNil(filteredViews, nil);
    STAssertEquals((NSUInteger)0, [filteredViews count], nil);
}

- (void) testDoesNotFiltersOutViewIfPredicateReturnsYES{
    DummyView *view = [[[DummyView alloc] init]autorelease];
    view.returnValue = YES;
    
    SYPredicateFilter *filter = [[[SYPredicateFilter alloc] initWithSelector:@selector(dummyMethod) args:[NSArray array]] autorelease];
    
    NSArray *filteredViews = [filter applyToView:view];
    STAssertNotNil(filteredViews, nil);
    STAssertEquals((NSUInteger)1, [filteredViews count], nil);
    STAssertEquals(view, [filteredViews objectAtIndex:0], nil);
}



@end
