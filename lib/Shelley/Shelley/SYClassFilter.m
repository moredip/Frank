//
//  SYClassFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYClassFilter.h"

@implementation SYClassFilter
@synthesize target=_targetClass;

+ (NSArray *) allDescendantsOf:(UIView *)view{
    NSMutableArray *descendants = [NSMutableArray array];
    for (UIView *subview in [view subviews]) {
        [descendants addObject:subview];
        [descendants addObjectsFromArray:[self allDescendantsOf:subview]];
    }
    return descendants;
}

- (id)initWithClass:(Class)class {
    self = [super init];
    if (self) {
        _targetClass = class;
    }
    return self;
}

-(NSArray *)applyToView:(UIView *)view{
    NSArray *allDescendants = [SYClassFilter allDescendantsOf:view];
    
    // TODO: look at using predicates
    NSMutableArray *filteredDescendants = [NSMutableArray array];
    for (UIView *descendant in allDescendants) {
        if( [descendant isKindOfClass:_targetClass] ){
            [filteredDescendants addObject:descendant];
        }
    }
    
    return filteredDescendants;
}

@end
