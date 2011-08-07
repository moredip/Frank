//
//  MapOperationCommand.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "MapOperationCommand.h"

#import "UIQuery.h"
#import "UIQueryWebView.h"
#import "JSON.h"
#import "Operation.h"
#import "DumpCommand.h"

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

	if( [operation appliesToObject:view] )
		return [operation applyToObject:view];
	
    UIQuery *wrappedView = nil;
    
    if( [view isKindOfClass:[UIWebView class]] )
    {
        wrappedView = [UIQueryWebView withViews:[NSMutableArray arrayWithObject:view]
                                      className:@"UIWebView"];
        
    }else
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
	
	NSDictionary *requestCommand = [requestBody JSONValue];
	NSString *queryString = [requestCommand objectForKey:@"query"];
	NSDictionary *operationDict = [requestCommand objectForKey:@"operation"];
	Operation *operation = [[[Operation alloc] initFromJsonRepresentation:operationDict] autorelease];
	
	UIQuery *query;
	
	@try {
		query = $( [NSMutableString stringWithString:queryString] );
	}
	@catch (NSException * e) {
		NSLog( @"Exception while executing query '%@':\n%@", queryString, e );
		return [self generateErrorResponseWithReason:@"invalid selector" andDetails:[e reason]];
	}
	
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:[[query views] count]];
	for (UIView *view in [query views]) {
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
