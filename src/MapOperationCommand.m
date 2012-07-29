//
//  MapOperationCommand.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "MapOperationCommand.h"

#import "FranklyProtocolHelper.h"

#import "ViewJSONSerializer.h"

#import "SelectorEngineRegistry.h"

#import "Operation.h"
#import "DumpCommand.h"
#import "UIQueryWebView.h"
#import "JSON.h"

@implementation MapOperationCommand

- (id) performOperation:(Operation *)operation onView:(UIView *)view {
    
	if( [operation appliesToObject:view] )
		return [operation applyToObject:view];
	
    UIQuery *wrappedView;

    if([view isKindOfClass:[UIWebView class]])
    {
        wrappedView = [UIQueryWebView withViews:[NSMutableArray
                                                 arrayWithObject:view]
                                      className:@"UIWebView"];
    } 
    else
    {
	// wrapping the view in a uiquery like this lets us perform operations like touch, flash, inspect, etc
        wrappedView = [UIQuery withViews:[NSMutableArray arrayWithObject:view]
									className:@"UIView"];
    }
    
	if( [operation appliesToObject:wrappedView] )
		return [operation applyToObject:wrappedView];
	
	return nil; 

}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    __block NSString* response = nil;
	
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSDictionary *requestCommand = [requestBody JSONValue];
        
        NSString *selectorEngineString = [requestCommand objectForKey:@"selector_engine"];
        if( !selectorEngineString )
            selectorEngineString = @"uiquery"; // default to UIQuery, for compatibility with old clients
        
        NSString *selector = [requestCommand objectForKey:@"query"];
        NSDictionary *operationDict = [requestCommand objectForKey:@"operation"];
        Operation *operation = [[[Operation alloc] initFromJsonRepresentation:operationDict] autorelease];
        
        NSArray *viewsToMap = nil;
        @try {
            viewsToMap = [SelectorEngineRegistry selectViewsWithEngineNamed:selectorEngineString usingSelector:selector];
        }
        @catch (NSException * e) {
            NSLog( @"Exception while using %@ to select views with '%@':\n%@", selectorEngineString, selector, e );
            response = [[FranklyProtocolHelper generateErrorResponseWithReason:@"invalid selector" andDetails:[e reason]] retain];
            return;
        }
        
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:[viewsToMap count]];
        for (UIView *view in viewsToMap) {
            @try {
                id result = [self performOperation:operation onView:view];
                [results addObject:[ViewJSONSerializer jsonify:result]];
            }
            @catch (NSException * e) {
                NSLog( @"Exception while performing operation %@\n%@", operation, e );
                NSString* message = [NSString stringWithFormat:@"encountered error while attempting to perform %@ on selected elements", operation];
                response = [[FranklyProtocolHelper generateErrorResponseWithReason:message andDetails:[e reason]] retain];
                return;
            }
        }
        
        response = [[FranklyProtocolHelper generateSuccessResponseWithResults: results] retain];
    });
    
    [response autorelease];
    
    return response;
}

@end
