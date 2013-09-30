//
//  SelectorEngineProtocols.h
//  Frank
//
//  Created by Oleksiy Radyvanyuk on 9/29/13.
//
//

#import <Foundation/Foundation.h>

/**
 Please use object implementing @c SelectorEngineApplication protocol in selector engines rather than directly referencing
 @code [UIApplication sharedApplication]
 @endcode
 or
 @code [NSApplication sharedApplication]
 @endcode
 object
 */
@protocol SelectorEngineApplication <NSObject>

- (NSArray *)windows;

@end

@protocol SelectorEngine <NSObject>

@property (nonatomic, assign) __weak id<SelectorEngineApplication> application;

- (NSArray *) selectViewsWithSelector:(NSString *)selector;

@end
