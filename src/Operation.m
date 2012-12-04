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

- (void)castNumber:(NSNumber *)number toType:(const char*)objCType intoBuffer:(void *)buffer{
	// specific cases should be added here as needed
	if( !strcmp(objCType, @encode(int)) ){
		*((int *)buffer) = [number intValue];
	}else if( !strcmp(objCType, @encode(uint)) ){
		*((uint *)buffer) = [number unsignedIntValue];
	}else if( !strcmp(objCType, @encode(double)) ){
		*((double *)buffer) = [number doubleValue];
	} else if ( !strcmp(objCType, @encode(char)) ) {
		*((char*)buffer) = [number charValue];
	} else if ( !strcmp(objCType, @encode(float)) ){
		*((float *)buffer) = [number floatValue];
	} else {
		NSLog(@"Didn't know how to convert NSNumber to type %s", objCType); 
	}	
}

- (id) applyToObject:(id)target {
	NSMethodSignature *signature = [target methodSignatureForSelector:_selector];
	NSUInteger requiredNumberOfArguments = signature.numberOfArguments - 2; // Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively
	if( requiredNumberOfArguments != [_arguments count] )
#if TARGET_OS_IPHONE
		[NSException raise:@"wrong number of arguments"
					format:@"%@ takes %i arguments, but %i were supplied", NSStringFromSelector(_selector), requiredNumberOfArguments, [_arguments count] ];
#else
        [NSException raise:@"wrong number of arguments"
                    format:@"%@ takes %lu arguments, but %lu were supplied", NSStringFromSelector(_selector), requiredNumberOfArguments, [_arguments count] ];
#endif
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:_selector];
	
	char invocationBuffer[300]; //let's hope we don't get asked to invoke a method with more than 28 arguments.
	
	NSInteger index = 2; // Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively
	for( id arg in _arguments ) {
		if( [arg isKindOfClass:[NSNumber class]] ){
			void *buffer = &(invocationBuffer[index*10]);
			[self castNumber:arg toType:[signature getArgumentTypeAtIndex:index] intoBuffer:buffer];
			[invocation setArgument:buffer atIndex:index];
		}else {
			[invocation setArgument:&arg atIndex:index];
		}
		index++;
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
