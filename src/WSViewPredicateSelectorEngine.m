//
//  WSViewPredicateSelectorEngine.m
//  Saturn
//
//  Created by Brian King on 11/29/11.
//  Copyright 2011 AgaMatrix, Inc. All rights reserved.
//

#import "WSViewPredicateSelectorEngine.h"
#import "UIView+AccessibilityLabelLookup.h"

@implementation WSViewPredicateSelectorEngine

+(void)load {
    WSViewPredicateSelectorEngine *registeredInstance = [[self alloc]init];
    [SelectorEngineRegistry registerSelectorEngine:registeredInstance WithName:@"predicate_lookup"];
    [registeredInstance release];
}

- (NSArray *) selectViewsWithSelector:(NSString *)selector {
    NSLog( @"Using WSViewPredicateSelectorEngine to select views with selector: %@", selector );
    return [[UIApplication sharedApplication].keyWindow subviewsMatchingPredicate:selector];
}

@end
