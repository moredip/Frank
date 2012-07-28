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
#import "ViewJSONSerializer.h"
#import "FranklyProtocolHelper.h"

@implementation AppCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	
	NSDictionary *requestCommand = [requestBody JSONValue];
	NSDictionary *operationDict = [requestCommand objectForKey:@"operation"];
	Operation *operation = [[[Operation alloc] initFromJsonRepresentation:operationDict] autorelease];
	
	id <UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	
	if( ![operation appliesToObject:appDelegate] )
	{
		return [FranklyProtocolHelper generateErrorResponseWithReason:@"operation doesn't apply" andDetails:@"operation does not appear to be implemented in app delegate"];
	}
	
    NSMutableArray* results = [NSMutableArray new];
    __block NSException* exn;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        id result;
        @try {
            result = [operation applyToObject:appDelegate];
        }
        @catch (NSException *e) {
            NSLog( @"Exception while applying operation to app delegate:\n%@", e );
            exn = e;
            return;
        }
        
        [results addObject:[ViewJSONSerializer jsonify:result]];
    });
	
    if (exn) {
        return [FranklyProtocolHelper generateErrorResponseWithReason:@"exception while executing operation" andDetails:[exn reason]];
    }
    
	return [FranklyProtocolHelper generateSuccessResponseWithResults: results];
}

@end
