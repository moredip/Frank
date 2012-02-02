//
//  SenTestCase+Extensions.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SenTestCase+Extensions.h"


@implementation SenTestCase (Extensions)


- (void) assertArray:(NSArray *)array containsObjects:(NSArray *)objects{
    for (id obj in objects) {
        [self assertArray:array containsObject:obj];
    }
}

- (void) assertArray:(NSArray *)array containsExactlyObjects:(NSArray *)objects{
    STAssertEquals([objects count], [array count], nil);
    [self assertArray:array containsObjects:objects];
}

- (void) assertArray:(NSArray *)array containsObject:(id)object{
    STAssertTrue( [array containsObject:object], nil );
}

@end
