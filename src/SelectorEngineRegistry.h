//
//  SelectorEngineRegistry.h
//  Frank
//
//  Created by Thought Worker on 11/10/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectorEngine <NSObject>

@optional

/* Multi-window behaviour for selector engines that only implement this method is
 * undefined. If an engine supports querying across multiple windows, it should
 * implement the below method instead.
 */
- (NSArray *) selectViewsWithSelector:(NSString *)selector;

/* If a selector engine implements this method, it should return all matching views in
 * any of the windows provided. Currently only supported on iOS.
 */
- (NSArray *) selectViewsWithSelector:(NSString *)selector inWindows:(NSArray *)windows;

@end

@interface SelectorEngineRegistry : NSObject{
}

+ (void) registerSelectorEngine:(id<SelectorEngine>)engine WithName:(NSString *)name;
+ (NSArray *) selectViewsWithEngineNamed:(NSString *)engineName usingSelector:(NSString *)selector;

+ (NSArray *)getEngineNames;
@end
