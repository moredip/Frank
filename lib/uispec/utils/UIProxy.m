#import "UIProxy.h"

@implementation UIProxy

@synthesize target;

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
	if ([target respondsToSelector:aSelector]) {
		return [target methodSignatureForSelector:aSelector];
	}
	return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	[anInvocation invokeWithTarget:target];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	return [target respondsToSelector:aSelector];
}

-(NSString *)description {
	return [NSString stringWithFormat:@"Proxy: %@", [target description]];
}

-(void)dealloc {
	self.target = nil;
	[super dealloc];
}

@end
