//
//  SenTestCase+Extensions.h
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface SenTestCase(Extensions)
- (void) assertArray:(NSArray *)array containsObjects:(NSArray *)objects;
- (void) assertArray:(NSArray *)array containsExactlyObjects:(NSArray *)objects;
- (void) assertArray:(NSArray *)array containsObject:(id)object;
@end
