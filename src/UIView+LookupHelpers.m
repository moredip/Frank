//
//  UIView+LookupHelpers.m
//  Saturn
//
//  Created by Brian King on 11/29/11.
//  Copyright 2011 AgaMatrix, Inc. All rights reserved.
//

#import "UIView+LookupHelpers.h"
#import "UIView-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"


@interface BKKVPLookupHelper : NSObject
{
    id _target;
    SEL _selector;
}

- (id)initWithTarget:(id)target forSelector:(SEL)selector;

@end

@implementation BKKVPLookupHelper

- (id)initWithTarget:(id)target forSelector:(SEL)selector
{
    self = [super init];
    if (self)
    {
        _target = [target retain];
        _selector = selector;
    }
    return self;
}

- (id)valueForKey:(NSString *)key
{
    return [_target performSelector:_selector withObject:key];
}

- (void)dealloc
{
    [_target release];
    [super dealloc];
}

@end


@implementation UIView(BKLookupHelpers)

- (id)subviewsByAccessibilityLabel
{
    return [[[BKKVPLookupHelper alloc] initWithTarget:self forSelector:@selector(subviewContainingAccessibilityLabel:)] autorelease];
}      

- (UIView *)subviewContainingAccessibilityLabel:(NSString *)label
{
    UIAccessibilityElement *element = [self accessibilityElementWithLabel:label];
    
    UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];

    return view;
}

- (NSArray *)subviewsMatchingPredicate:(id)stringOrPredicate
{
    NSParameterAssert([stringOrPredicate isKindOfClass:[NSString class]] || 
                      [stringOrPredicate isKindOfClass:[NSPredicate class]]);
    
    NSPredicate *predicate = stringOrPredicate;
    if ([stringOrPredicate isKindOfClass:[NSString class]])
        predicate = [NSPredicate predicateWithFormat:stringOrPredicate];

    NSMutableArray *results = [[NSMutableArray alloc] init];

    @try {
        if ([predicate evaluateWithObject:self])
            [results addObject:self];
    }
    @catch (NSException * e) {
        // Predicate key paths may be fragile on different view heirarchies, inform them and continue
        NSLog(@"Fragile predicate threw exception: %@", e);
    }

    for (UIView *view in self.subviews)
        [results addObjectsFromArray:[view subviewsMatchingPredicate:predicate]];

    return results;
}

@end
