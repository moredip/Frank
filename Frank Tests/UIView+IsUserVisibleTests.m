//
//  UIView+IsUserVisibleTests.m
//  Frank
//
//  Created by Robert Gilliam on 7/4/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "UIView+Frank.h"
#import "NonOpaqueViewForTesting.h"

@interface UIView_IsUserVisibleTests : SenTestCase

@end



@implementation UIView_IsUserVisibleTests {
    UIWindow *window;
    
    UIView *occludedView;
}

- (void)setUp
{
    window = [[UIWindow alloc] init];

    occludedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [window addSubview:occludedView];
    [window makeKeyAndVisible];
}

- (void)testSingleViewUserVisible
{
    STAssertTrue([occludedView FEX_userVisible], nil);
}

- (void)testWindowUserVisible
{
    STAssertTrue([window FEX_userVisible], nil);
}

- (void)testViewNotVisibleIsNotUserVisible
{
    [occludedView setHidden:YES];
    
    STAssertFalse([occludedView FEX_userVisible], nil);
}

- (void)testCompletelyOccludedByOpaqueSibling
{
    UIView *opaqueSibling = [[UIView alloc] initWithFrame:[occludedView frame]];
    opaqueSibling.alpha = 1.0;
    
    [window addSubview:opaqueSibling];
    
    STAssertFalse([occludedView FEX_userVisible], nil);
    STAssertTrue([opaqueSibling FEX_userVisible], nil);
}

- (void)testCompletelyOccludedByTransparentSibling
{
    UIView *transparentSibling = [[UIView alloc] initWithFrame:[occludedView frame]];
    transparentSibling.alpha = 0.4;
    
    [window addSubview:transparentSibling];
    
    STAssertTrue([occludedView FEX_userVisible], nil);
    STAssertTrue([transparentSibling FEX_userVisible], nil);
}

- (void)testOccludedByAClearViewIncorrectlyMarkedOpaque
{
    UIView *clearViewMarkedOpaque = [[UIView alloc] initWithFrame:[occludedView frame]];
    clearViewMarkedOpaque.backgroundColor = [UIColor clearColor];
    
    [window addSubview:clearViewMarkedOpaque];
    
    STAssertTrue([clearViewMarkedOpaque isOpaque], nil);
    STAssertFalse([occludedView FEX_userVisible], nil);
    STAssertTrue([clearViewMarkedOpaque FEX_userVisible], nil);
}

- (void)testOccludedByANonOpaqueView
{
    UIView *nonOpaqueView = [[NonOpaqueViewForTesting alloc] initWithFrame:[occludedView frame]];
    STAssertFalse([nonOpaqueView isOpaque], nil);
    
    [window addSubview:nonOpaqueView];
    
    STAssertTrue([occludedView FEX_userVisible], nil);
    STAssertTrue([nonOpaqueView FEX_userVisible], nil);
}

- (void)testPartiallyOccluded
{
    UIView *partiallyOverlappingSibling = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];

    [window addSubview:partiallyOverlappingSibling];
    
    STAssertTrue([occludedView FEX_userVisible], nil);
    STAssertTrue([partiallyOverlappingSibling FEX_userVisible], nil);
}

- (void)testSuperviewCompletelyOccludedByOpaqueSibling
{
    UIView *occludedSubview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
    [occludedView addSubview:occludedSubview];
    
    UIView *opaqueSibling = [[UIView alloc] initWithFrame:[occludedView frame]];
    opaqueSibling.alpha = 1.0;
    
    [window addSubview:opaqueSibling];
    
    STAssertFalse([occludedView FEX_userVisible], nil);
    STAssertFalse([occludedSubview FEX_userVisible], nil);
    STAssertTrue([opaqueSibling FEX_userVisible], nil);
}

@end
