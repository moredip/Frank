//
//  AppCommand.m
//  Chase.Mobi
//
//  Created by Pete Hodgson on 10/6/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import <Foundation/Foundation.h>
#import "AppCommand.h"

#import "Operation.h"
#import "ViewJSONSerializer.h"
#import "FranklyProtocolHelper.h"
#import "JSON.h"

@implementation AppCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	
	NSDictionary *requestCommand = FROM_JSON(requestBody);
	NSDictionary *operationDict = [requestCommand objectForKey:@"operation"];
	Operation *operation = [[[Operation alloc] initFromJsonRepresentation:operationDict] autorelease];
	
#if TARGET_OS_IPHONE
    id <UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
#else
    id <NSApplicationDelegate> appDelegate = [[NSApplication sharedApplication] delegate];
#endif
	
	if( ![operation appliesToObject:appDelegate] )
	{
		return [FranklyProtocolHelper generateErrorResponseWithReason:@"operation doesn't apply" andDetails:@"operation does not appear to be implemented in app delegate"];
	}
	
	id result;
	
	@try {
		result = [operation applyToObject:appDelegate];
	}
	@catch (NSException *e) {
		NSLog( @"Exception while applying operation to app delegate:\n%@", e );
		return [FranklyProtocolHelper generateErrorResponseWithReason:@"exception while executing operation" andDetails:[e reason]];
	}
	
    NSMutableArray *results = [NSMutableArray new];
	[results addObject:[ViewJSONSerializer jsonify:result]];
	
	return [FranklyProtocolHelper generateSuccessResponseWithResults: results];
}

@end
