//
//  SYParserTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParserTests.h"
#import "SYParser.h"
#import "SYDescendants.h"
#import "SYParents.h"

@implementation SYParserTests

- (void) testViewSelectorYieldsASingleDescendentOperator{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertTrue([filter isKindOfClass:[SYDescendants class]], nil);
    
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
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view invalid"];
    
    id<SYFilter> filter = [parser nextFilter];
    STAssertNotNil(filter, nil);
    
    STAssertThrows([parser nextFilter], nil);
}

// test invalid selector keyword



@end
