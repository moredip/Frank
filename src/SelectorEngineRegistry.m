//
//  SelectorEngineRegistry.m
//  Frank
//
//  Created by Thought Worker on 11/10/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "SelectorEngineRegistry.h"
#import "FrankApplication.h"

static NSMutableDictionary *s_engines;
static FrankApplication *s_application;

@implementation SelectorEngineRegistry

+ (void)initialize {
    s_engines = [[NSMutableDictionary alloc] init];
    s_application = [[FrankApplication alloc] init];
}

+ (void) registerSelectorEngine:(id<SelectorEngine>)engine WithName:(NSString *)string {
    // make sure we are setting application wrapper to the selector engine that expects it to be set
    if ([engine respondsToSelector:@selector(application)]) {
        // set up application wrapper here. Its primary purpose is to give the selector engine correct set of windows to work with
        engine.application = s_application;
    }
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
