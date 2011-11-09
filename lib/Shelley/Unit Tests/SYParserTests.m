//
//  SYParserTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParserTests.h"
#import "SYParser.h"
#import "SYParents.h"
#import "SYPredicateFilter.h"
#import "SYClassFilter.h"
#import "SYNthElementFilter.h"

@implementation SYParserTests

- (void) testViewSelectorYieldsAClassFilter{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYClassFilter class]], nil);
    STAssertEquals([(SYClassFilter *)filter target], [UIView class], nil);
    
    filter = [parser nextFilter];
    STAssertNil( filter, nil );
}

- (void) testParentSelectorYieldsASingleParentsOperator{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"parent"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYParents class]], nil);

    filter = [parser nextFilter];
    STAssertNil( filter, nil );    
}

- (void) testInvalidSelectorEventuallyCausesParserToBomb{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view invalid-string"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertNotNil(filter, nil);
    
    STAssertThrows([parser nextFilter] && [parser nextFilter], nil);
}

- (void) testNoArgPredicateSelectorParses{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"noArgMethod"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYPredicateFilter class]], nil);
    
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    STAssertEquals((SEL)[predicateFilter selector], @selector(noArgMethod), nil);
    STAssertEquals([[predicateFilter args] count], (NSUInteger)0, nil );

}

- (void) testSingleArgPredicateSelectorParses{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"singleArg:123"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYPredicateFilter class]], nil);
    
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    STAssertEquals((SEL)[predicateFilter selector], @selector(singleArg:), nil);
    STAssertEquals([[predicateFilter args] count], (NSUInteger)1,nil );
    
    NSNumber *firstArg = [[predicateFilter args] objectAtIndex:0];
    STAssertTrue( [firstArg isEqualToNumber:[NSNumber numberWithInt:123]], nil);
}

- (void) testMultiArgPredicateSelectorParses{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"argOne:123argTwo:'foo'argThree:789"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYPredicateFilter class]], nil);
    
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    STAssertEquals((SEL)[predicateFilter selector], @selector(argOne:argTwo:argThree:), nil);
    STAssertEquals([[predicateFilter args] count], (NSUInteger)3,nil );
    
    NSNumber *firstArg = [[predicateFilter args] objectAtIndex:0];
    STAssertTrue( [firstArg isEqualToNumber:[NSNumber numberWithInt:123]], nil);

    NSString *secondArg = [[predicateFilter args] objectAtIndex:1];
    STAssertTrue( [secondArg isEqualToString:@"foo"], nil);
    
    NSNumber *thirdArg = [[predicateFilter args] objectAtIndex:2];
    STAssertTrue( [thirdArg isEqualToNumber:[NSNumber numberWithInt:789]], nil);
}

- (void) testParsesSingleQuoteStringArguments {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"foo:'xyz'"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYPredicateFilter class]], nil);
    
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    STAssertEquals((SEL)[predicateFilter selector], @selector(foo:), nil);
    STAssertEquals([[predicateFilter args] count], (NSUInteger)1,nil );
    STAssertTrue([[[predicateFilter args] objectAtIndex:0] isEqualToString:@"xyz"],nil );
}

- (void) testParsesDoubleQuoteStringArguments {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"foo:\"xyz\""];
    
    id<SYFilter> filter = [parser nextFilter];
    
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    STAssertEquals((SEL)[predicateFilter selector], @selector(foo:), nil);
    STAssertEquals([[predicateFilter args] count], (NSUInteger)1,nil );
    STAssertTrue([[[predicateFilter args] objectAtIndex:0] isEqualToString:@"xyz"],nil );
}

- (void) testParsesQuotedStringsContainingSpaces {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"foo:'string with spaces'"];
    
    id<SYFilter> filter = [parser nextFilter];
    
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    STAssertEquals([[predicateFilter args] count], (NSUInteger)1,nil );
    STAssertTrue([[[predicateFilter args] objectAtIndex:0] isEqualToString:@"string with spaces"],nil );

}

- (void) testButtonShorthandClassSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"button"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYClassFilter class]], nil);
    STAssertEquals([(SYClassFilter *)filter target], [UIButton class], nil);
}


- (void) testMiscellaneousShorthandClassSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"navigationButton"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYClassFilter class]], nil);
    STAssertNotNil([(SYClassFilter *)filter target], nil);
    STAssertEquals([(SYClassFilter *)filter target], NSClassFromString(@"UINavigationButton"), nil);
    
    parser = [[SYParser alloc] initWithSelectorString:@"navigationItemView"];
    
    filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYClassFilter class]], nil);
    STAssertNotNil([(SYClassFilter *)filter target], nil);
    STAssertEquals([(SYClassFilter *)filter target], NSClassFromString(@"UINavigationItemView"), nil);
    
    parser = [[SYParser alloc] initWithSelectorString:@"alertView"];
    
    filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYClassFilter class]], nil);
    STAssertNotNil([(SYClassFilter *)filter target], nil);
    STAssertEquals([(SYClassFilter *)filter target], [UIAlertView class], nil);

}


- (void) testFirstSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"first"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYNthElementFilter class]], nil);
    STAssertEquals( [(SYNthElementFilter *)filter index], (NSUInteger)0, nil );
}

- (void) testIndexSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"index:124"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYNthElementFilter class]], nil);
    STAssertEquals( [(SYNthElementFilter *)filter index], (NSUInteger)124, nil );
    
}


- (void) testExplicitClassSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view:'UITextView' somePredicate:'method'"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYClassFilter class]], nil);
    STAssertEquals([(SYClassFilter *)filter target], [UITextView class], nil);
    
    filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYPredicateFilter class]], nil);
    
    filter = [parser nextFilter];
    STAssertNil(filter, nil);
}


@end
