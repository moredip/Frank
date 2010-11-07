//
//  AppCommand.m
//  Chase.Mobi
//
//  Created by Pete Hodgson on 10/6/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import <Foundation/Foundation.h>

#import "AppCommand.h"

#import "UIQuery.h"
#import "JSON.h"
#import "Operation.h"

@implementation AppCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	
	NSDictionary *requestCommand = [requestBody JSONValue];
	NSDictionary *operationDict = [requestCommand objectForKey:@"operation"];
	Operation *operation = [[[Operation alloc] initFromJsonRepresentation:operationDict] autorelease];
	
	id <UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	
	if( ![operation appliesToObject:appDelegate] )
	{
		return @"{ \"outcome\":\"ERROR\", \"reason\":\"operation doesn't apply\", \"details\":\"operation does not appear to be implemented in app delegate\"}";
	}
	
	@try {
		[operation applyToObject:appDelegate];
	}
	@catch (NSException *e) {
		NSLog( @"Exception while applying operation to app delegate:\n%@", e );
		return [NSString stringWithFormat:@"{ \"outcome\":\"ERROR\", \"reason\":\"exception while executing operation\", \"details\":\"%@\"}", [e reason]];
	}
	
	// ignore results for now, and just assume success
	return @"{\"outcome\":\"SUCCESS\"}";
}

@end
