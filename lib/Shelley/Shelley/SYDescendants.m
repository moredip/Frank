//
//  SYDescendants.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYDescendants.h"


@implementation SYDescendants

+ (NSArray *) allDescendantsOf:(UIView *)view{
    NSMutableArray *descendants = [NSMutableArray array];
    for (UIView *subview in [view subviews]) {
        [descendants addObject:subview];
        [descendants addObjectsFromArray:[self allDescendantsOf:subview]];
    }
    return descendants;
}

-(NSArray *)applyToView:(UIView *)view{
    return [SYDescendants allDescendantsOf:view];
}

@end
