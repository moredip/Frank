//
//  MapOperationCommand.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "MapOperationCommand.h"

#import "UIQuery.h"
#import "Shelley.h"
#import "JSON.h"
#import "Operation.h"
#import "DumpCommand.h"
#import "UIQueryWebView.h"

@implementation MapOperationCommand

- (NSString *)generateErrorResponseWithReason:(NSString *)reason andDetails:(NSString *)details{
	NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys: 
							  @"ERROR", @"outcome",
							  reason, @"reason", 
							  details, @"details",
							  nil];
	return [response JSONRepresentation];
}
- (NSString *)generateSuccessResponseWithResults:(NSArray *)results{
	NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys: 
							  @"SUCCESS", @"outcome",
							  results, @"results",
							  nil];
	return [response JSONRepresentation];
}

- (id) performOperation:(Operation *)operation onView:(UIView *)view {

    NSString *className = NSStringFromClass([view class]); 
    
	if( [operation appliesToObject:view] )
		return [operation applyToObject:view];
	
    UIQuery *wrappedView;
    
    
    if ([className isEqualToString:@"UIWebView"])
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

- (NSArray *)selectViewsUsingUIQueryWithSelector:(NSString *)queryString{
    NSLog( @"Using UIQuery to select views with selector: %@", queryString );
	UIQuery *query = $( [NSMutableString stringWithString:queryString] );
    return [query views];
}

- (NSArray *)selectViewsUsingShelleyWithSelector:(NSString *)queryString{
    NSLog( @"Using Shelley to select views with selector: %@", queryString );
    Shelley *shelley = [Shelley withSelectorString:queryString];
	return [shelley selectFrom:[[UIApplication sharedApplication] keyWindow]];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	
	NSDictionary *requestCommand = [requestBody JSONValue];
    
	NSString *selectorEngineString = [requestCommand objectForKey:@"selector_engine"];
	NSString *queryString = [requestCommand objectForKey:@"query"];
	NSDictionary *operationDict = [requestCommand objectForKey:@"operation"];
	Operation *operation = [[[Operation alloc] initFromJsonRepresentation:operationDict] autorelease];
    
    NSArray *viewsToMap = nil;
    @try {
        if( [selectorEngineString isEqualToString:@"uiquery"] || selectorEngineString == nil )
        {
            viewsToMap = [self selectViewsUsingUIQueryWithSelector:queryString];
        }else if( [selectorEngineString isEqualToString:@"shelley_compat"] ){
            viewsToMap = [self selectViewsUsingShelleyWithSelector:queryString];
        }else{
            NSLog( @"Unrecognized selector_engine '%@'", selectorEngineString );
			return [self generateErrorResponseWithReason:@"unrecognized selector engine" 
											  andDetails:[NSString stringWithFormat:@"selector_engine '%@' unrecognized. Supported engines are 'uiquery' or 'shelley_compat'", selectorEngineString]];
        }
    }	
    @catch (NSException * e) {
		NSLog( @"Exception while using %@ to select views with '%@':\n%@", selectorEngineString, queryString, e );
		return [self generateErrorResponseWithReason:@"invalid selector" andDetails:[e reason]];
	}
	
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[viewsToMap count]];
	for (UIView *view in viewsToMap) {
		@try {
			id result = [self performOperation:operation onView:view];
			[results addObject:[DumpCommand jsonify:result]];
		}
		@catch (NSException * e) {
			NSLog( @"Exception while performing operation %@\n%@", operation, e );
			return [self generateErrorResponseWithReason: [ NSString stringWithFormat:@"encountered error while attempting to perform %@ on selected elements",operation] 
											  andDetails:[e reason]];
		}
	}
							   
   return [self generateSuccessResponseWithResults: results];
}

@end
