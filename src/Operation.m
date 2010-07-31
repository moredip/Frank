//
//  Operation.m
//  Frank
//
//  Created by phodgson on 6/27/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "Operation.h"


@implementation Operation

- (id) initFromJsonRepresentation:(NSDictionary *)operationDict {
	self = [super init];
	if (self != nil) {
		_selector =  NSSelectorFromString( [operationDict objectForKey:@"method_name"] );
		_arguments = [[operationDict objectForKey:@"arguments"] retain];
	}
	return self;
}

- (void) dealloc
{
	[_arguments release];
	[super dealloc];
}

- (NSString *) description {
	return NSStringFromSelector(_selector);
}

- (BOOL) appliesToObject:(id)target {
	return [target respondsToSelector:_selector];
}

- (id) applyToObject:(id)target {
	NSMethodSignature *signature = [target methodSignatureForSelector:_selector];
	NSUInteger requiredNumberOfArguments = signature.numberOfArguments - 2; // Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively
	if( requiredNumberOfArguments != [_arguments count] )
		[NSException raise:@"wrong number of arguments" 
					format:@"%@ takes %i arguments, but %i were supplied", NSStringFromSelector(_selector), requiredNumberOfArguments, [_arguments count] ];
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:_selector];
	
	NSInteger index = 2; // Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively
	for( id arg in _arguments ) {
		[invocation setArgument:&arg atIndex:index++];
	}
		 
	[invocation invokeWithTarget:target];

	
	const char *returnType = signature.methodReturnType;
	
	id returnValue;
	if( !strcmp(returnType, @encode(void)) )
		returnValue =  nil;
	else if( !strcmp(returnType, @encode(id)) ) // retval is an objective c object
	{
		[invocation getReturnValue:&returnValue];
	}else {
		// handle primitive c types by wrapping them in an NSValue
		
		NSUInteger length = [signature methodReturnLength];
		void *buffer = (void *)malloc(length);
		[invocation getReturnValue:buffer];
		
		// for some reason using [NSValue valueWithBytes:returnType] is creating instances of NSConcreteValue rather than NSValue, so 
		//I'm fudging it here with case-by-case logic
		if( !strcmp(returnType, @encode(BOOL)) ) 
		{
			returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
		}else if( !strcmp(returnType, @encode(NSInteger)) )
		{
			returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
		}else {
			returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
		}
		//free(buffer); memory leak here, but apparently NSValue doesn't copy the passed buffer, it just stores the pointer
	}
	return returnValue;	
}


@end
