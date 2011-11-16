//
//  SelectorEngineRegistry.h
//  Frank
//
//  Created by Thought Worker on 11/10/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectorEngine <NSObject>

- (NSArray *) selectViewsWithSelector:(NSString *)selector;

@end

@interface SelectorEngineRegistry : NSObject{
}

+ (void) registerSelectorEngine:(id<SelectorEngine>)engine WithName:(NSString *)name;
+ (NSArray *) selectViewsWithEngineNamed:(NSString *)engineName usingSelector:(NSString *)selector;

@end
