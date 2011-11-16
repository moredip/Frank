//
//  SYFrankSelectorEngine.m
//  Shelley
//
//  Created by Thought Worker on 11/11/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "SYFrankSelectorEngine.h"
#import "Shelley.h"

@implementation SYFrankSelectorEngine

+(void)load{
    SYFrankSelectorEngine *registeredInstance = [[self alloc]init];
    [SelectorEngineRegistry registerSelectorEngine:registeredInstance WithName:@"shelley_compat"];
    [registeredInstance release];
}

- (NSArray *) selectViewsWithSelector:(NSString *)selector {
    NSLog( @"Using Shelley to select views with selector: %@", selector );	
    
    Shelley *shelley = [Shelley withSelectorString:selector];
    return [shelley selectFrom:[[UIApplication sharedApplication] keyWindow]];
}


@end
