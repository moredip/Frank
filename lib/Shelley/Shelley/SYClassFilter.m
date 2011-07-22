//
//  SYClassFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYClassFilter.h"

#import "SYDescendants.h"

@implementation SYClassFilter

- (id)initWithClass:(Class)class {
    self = [super init];
    if (self) {
        _targetClass = class;
    }
    return self;
}

-(NSArray *)applyToView:(UIView *)view{
    NSArray *allDescendants = [SYDescendants allDescendantsOf:view];
    
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
