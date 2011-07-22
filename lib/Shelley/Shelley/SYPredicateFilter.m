//
//  SYPredicateFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 7/20/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYPredicateFilter.h"

@implementation SYPredicateFilter
@synthesize selector=_selector,args=_args;

- (id)initWithSelector:(SEL)selector args:(NSArray *)args {
    self = [super init];
    if (self) {
        _selector = selector;
        _args = [args copy];
    }
    return self;
}
- (void)dealloc {
    [_args release];
    [super dealloc];
}

- (void)castNumber:(NSNumber *)number toType:(const char*)objCType intoBuffer:(void *)buffer{
	// specific cases should be added here as needed
	if( !strcmp(objCType, @encode(int)) ){
		*((int *)buffer) = [number intValue];
	}else if( !strcmp(objCType, @encode(uint)) ){
		*((uint *)buffer) = [number unsignedIntValue];
	}else {
		NSLog(@"Didn't know how to convert NSNumber to type %s", objCType); 
	}	
}

- (NSInvocation *) createInvocationForObject:(id)object{
    NSMethodSignature *signature = [object methodSignatureForSelector:_selector];
    if( !signature )
        return nil;
    
    if( strcmp([signature methodReturnType], @encode(BOOL)) ){
        [NSException raise:@"wrong return type" 
					format:@"predicate does not return a BOOL"];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    NSUInteger requiredNumberOfArguments = signature.numberOfArguments - 2; // Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively
	if( requiredNumberOfArguments != [_args count] )
		[NSException raise:@"wrong number of arguments" 
					format:@"%@ takes %i arguments, but %i were supplied", NSStringFromSelector(_selector), requiredNumberOfArguments, [_args count] ];
	
	[invocation setSelector:_selector];
	
	char invocationBuffer[300]; //let's hope we don't get asked to invoke a method with more than 28 arguments.
	
	NSInteger index = 2; // Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively
	for( id arg in _args ) {
		if( [arg isKindOfClass:[NSNumber class]] ){
			void *buffer = &(invocationBuffer[index*10]);
			[self castNumber:arg toType:[signature getArgumentTypeAtIndex:index] intoBuffer:buffer];
			[invocation setArgument:buffer atIndex:index];
		}else {
			[invocation setArgument:&arg atIndex:index];
		}
		index++;
	}
    
    return invocation;
}

- (BOOL) extractBooleanReturnValueFromInvocation:(NSInvocation *)invocation{
    BOOL retval;
    [invocation getReturnValue:&retval];
    return retval;
}

-(NSArray *)applyToView:(UIView *)view{
    NSInvocation *invocation = [self createInvocationForObject:view];
    if( !invocation )
        return [NSArray array];
     
    [invocation invokeWithTarget:view];
    BOOL predicatePassed = [self extractBooleanReturnValueFromInvocation:invocation];
    
    if( predicatePassed )
        return [NSArray arrayWithObject:view];
    else
        return [NSArray array];
}

@end
