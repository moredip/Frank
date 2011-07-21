//
//  Shelley.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "Shelley.h"


@implementation Shelley

+ (Shelley *) withSelectorString:(NSString *)selectorString
{
    // TODO
    return [[[self alloc] init] autorelease];
}

+ (NSArray *) allDescendantsOf:(UIView *)view{
    NSMutableArray *descendants = [NSMutableArray array];
    for (UIView *subview in [view subviews]) {
        [descendants addObject:subview];
        [descendants addObjectsFromArray:[self allDescendantsOf:subview]];
    }
    return descendants;
}

- (NSArray *) selectFrom:(UIView *)rootView
{
    return [Shelley allDescendantsOf:rootView];
}

@end
