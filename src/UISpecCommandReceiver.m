//
//  UISpecCommandReceiver.m
//  UICatalog
//
//  Created by phodgson on 5/23/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "UISpecCommandReceiver.h"
#import "UIQuery.h"


@implementation UISpecCommandReceiver

- (NSArray *)performSelector:(NSString *)selectorString onViewsIn:(UIQuery *)query{
	NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[[query views]count]];
	for (NSObject *view in [query views]) {
		NSString *value = [NSString stringWithFormat:@"%@", [view performSelector:NSSelectorFromString(selectorString)] ];
		[resultArray addObject:value];
	}
	return resultArray;
}

- (NSString*)evaluateCommandInParts:(NSArray *)commandParts {
	NSString *commandType = [ (NSString *)[commandParts objectAtIndex:0] lowercaseString];
	NSString *queryString = (NSString *)[commandParts objectAtIndex:1];
	
	UIQuery *query;
	query = $( [NSMutableString stringWithString:queryString] );

	
	if( [@"perform" isEqual:commandType] )
		return @"DONE";
	else if( [@"get" isEqual:commandType] )
	{
		NSString *selectorString = (NSString *)[commandParts objectAtIndex:2];
		NSArray *values = [self performSelector:selectorString onViewsIn:query];
		return [values componentsJoinedByString:@"\n"];
	}else if ([@"inspect" isEqual:commandType]) {
		[query inspect];
		return @"INSPECTED";
	}else{
		return [NSString stringWithFormat:@"Unrecognized command type %@",commandType];
	}	
}

- (NSString*)runCommandStep:(NSData*)commandAsData {
	NSString *command = [[NSString alloc] initWithData:commandAsData encoding:NSASCIIStringEncoding];
	
	NSLog( @"Received UISpec Command: %@",command);
	NSArray *commandParts = [command componentsSeparatedByString:@"\n"];
	
	
	
	@try {
		NSString *result = [self evaluateCommandInParts:commandParts];
		NSLog( @"Returning:\n%@",result);
		return result;
	}
	@catch (NSException * e) {
		NSLog( @"Exception!: %@", e );
		return [NSString stringWithFormat: @"Exception! %@", e];
	}
}


@end
