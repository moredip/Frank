#import "Recordable.h"

@implementation Recordable

@synthesize target, invocation;

+(id)withTarget:(id)target {
	return [[[self alloc] initWithTarget:target] autorelease];
}

-(id)initWithTarget:(id)_target {
	if (self = [super init]) {
		self.target = _target;
	}
	return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [target methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	//NSLog(@"**Recordable forwardInvocation selector %@", NSStringFromSelector(anInvocation.selector));
	//[anInvocation retainArguments];
	NSString *returnType = [NSString stringWithFormat:@"%s", [[anInvocation methodSignature] methodReturnType]];
	if (![returnType isEqualToString:@"v"]) {
		[anInvocation setReturnValue:&self];
	}
	self.invocation = anInvocation;	
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	return [target respondsToSelector:aSelector];
}

-(id)play {
	NSLog(@"**START playing %@", NSStringFromSelector(invocation.selector));
	[invocation setTarget:target];
	[invocation invoke];
	NSString *returnType = [NSString stringWithFormat:@"%s", [[invocation methodSignature] methodReturnType]];
	if (![returnType isEqualToString:@"(null)"] && ![returnType isEqualToString:@"v"]) {
		id value;
		[invocation getReturnValue:&value];
		NSLog(@"**END playing %@", NSStringFromSelector(invocation.selector));
		return value;
	} else {
		NSLog(@"**END playing %@", NSStringFromSelector(invocation.selector));
		return nil;
	}
}

-(void)dealloc {
	self.target = nil;
	self.invocation = nil;
	[super dealloc];
}

@end
