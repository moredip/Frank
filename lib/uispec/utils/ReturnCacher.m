

#import "ReturnCacher.h"


@implementation ReturnCacher

@synthesize callCache;

-(id)initWithTarget:(id)_target {
	if (self = [super initWithTarget:_target]) {
		self.callCache = [[[CallCache alloc] init] autorelease];
	}
	return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSString *returnType = [NSString stringWithFormat:@"%s", [[anInvocation methodSignature] methodReturnType]];
	if (![returnType isEqualToString:@"v"]) {
		NSMutableArray *invocationsForSelector = [callCache get:NSStringFromSelector([anInvocation selector])];
		if (invocationsForSelector == nil) {
			invocationsForSelector = [NSMutableArray array];
			[callCache set:invocationsForSelector for:NSStringFromSelector([anInvocation selector])];
		}
		
		NSInvocation *cachedInvocation = [self invocationInArray:invocationsForSelector withMatchingArgValues:anInvocation];
		if (cachedInvocation != nil) {
			id cachedResult = nil;
			[cachedInvocation getReturnValue:&cachedResult];
			[anInvocation setReturnValue:&cachedResult];
		} else {
			[anInvocation invokeWithTarget:target];
			[invocationsForSelector addObject:anInvocation];
		}
	} else {
		[super forwardInvocation:anInvocation];
	}
}

+(NSInvocation *)invocationInArray:(NSArray *)array withMatchingArgValues:(NSInvocation *)invocation {
	id value = nil;
	id valueInInvocationInArray = nil;
	for (NSInvocation *invocationInArray in array) {
		BOOL matches = YES;
		for (int i = 2; i < [[invocation methodSignature] numberOfArguments]; i++) {
			[invocation getArgument:&value atIndex:i];
			[invocationInArray getArgument:&valueInInvocationInArray atIndex:i];
			
			NSValue *invocationValue = [NSValue valueWithBytes:&value objCType:[[invocation methodSignature] getArgumentTypeAtIndex:i]];
			NSValue *invocationInArrayValue = [NSValue valueWithBytes:&valueInInvocationInArray objCType:[[invocation methodSignature] getArgumentTypeAtIndex:i]];
			if (![invocationInArrayValue isEqualToValue:invocationValue]) {
				matches = NO;
				break;
			}
		}
		if (matches) {
			return invocationInArray;
		}
	}
	return nil;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"CallCacher: %@", [target description]];
}

-(void)dealloc {
	self.callCache = nil;
	[super dealloc];
}

@end

