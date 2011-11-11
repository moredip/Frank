//
//  UIQuerySelectorEngine.m
//  Frank
//
//  Created by Thought Worker on 11/10/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "UIQuerySelectorEngine.h"
#import "UIQuery.h"

@implementation UIQuerySelectorEngine

+(void)load{
    UIQuerySelectorEngine *registeredInstance = [[self alloc]init];
    [SelectorEngineRegistry registerSelectorEngine:registeredInstance WithName:@"uiquery"];
    [registeredInstance release];
}

- (NSArray *) selectViewsUsingShelleyWithSelector:(NSString *)selector {
    NSLog( @"Using UIQuery to select views with selector: %@", selector );
	UIQuery *query = $( [NSMutableString stringWithString:selector] );
    return [query views];
}


@end
