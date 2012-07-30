//
//  SelectorEngineRegistry.m
//  Frank
//
//  Created by Thought Worker on 11/10/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "SelectorEngineRegistry.h"

static NSMutableDictionary *s_engines;

@implementation SelectorEngineRegistry

+ (void)initialize {
    s_engines = [[NSMutableDictionary alloc] init];
}

+ (void) registerSelectorEngine:(id<SelectorEngine>)engine WithName:(NSString *)string {
    [s_engines setObject:engine forKey:string];
}

+ (NSArray *) selectViewsWithEngineNamed:(NSString *)engineName usingSelector:(NSString *)selector {
    id<SelectorEngine> engine = [s_engines objectForKey:engineName];
    if( !engine ){
        [NSException raise:@"unrecognized engine" format:@"engine named '%@' hasn't been registered with the SelectorEngineRegistry", engineName];
    }
    
    return [engine selectViewsWithSelector:selector];
}

+ (NSArray *)getEngineNames {
    return [s_engines allKeys];
}
@end
