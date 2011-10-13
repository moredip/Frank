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
    return [self initWithClass:class includeSelf:NO];
}

- (id)initWithClass:(Class)class includeSelf:(BOOL)includeSelf {
    self = [super init];
    if (self) {
        _targetClass = class;
		_includeSelf = includeSelf;
        _justFilter = NO;
    }
    return self;
}

- (void)setDoNotDescend:(BOOL)doNotDescend {
    _justFilter = doNotDescend;
}

-(NSArray *)viewsToConsiderFromView:(UIView *)view{
    if( _justFilter )
        return [NSArray arrayWithObject:view];
    
    NSMutableArray *allViews = _includeSelf ? [NSMutableArray arrayWithObject:view] : [NSMutableArray array];
    [allViews addObjectsFromArray:[SYClassFilter allDescendantsOf:view]];
    return allViews;
}


-(NSArray *)applyToView:(UIView *)view{
    NSArray *allViews = [self viewsToConsiderFromView:view];
	
    // TODO: look at using predicates
    NSMutableArray *filteredDescendants = [NSMutableArray array];
    for (UIView *v in allViews) {
        if( [v isKindOfClass:_targetClass] ){
            [filteredDescendants addObject:v];
        }
    }
    
    return filteredDescendants;
}

@end
