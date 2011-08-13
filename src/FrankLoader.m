//
//  FrankLoader.m
//  FrankFramework
//
//  Created by Pete Hodgson on 8/12/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "FrankLoader.h"

#import "FrankServer.h"

@implementation FrankLoader

+ (void)applicationDidBecomeActive:(NSNotification *)notification{
    FrankServer *server = [[FrankServer alloc] initWithDefaultBundle];
    [server startServer];
}

+ (void)load{
    NSLog(@"Injecting Frank loader");
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:@"UIApplicationDidBecomeActiveNotification" 
                                               object:nil];
}

@end
