
#import "WaitUntilIdle.h"


@implementation WaitUntilIdle

@synthesize invocation;

-(id)initWithTarget:(id)_target {
	if (self = [super initWithTarget:_target]) {
		isIdle = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:[NSString stringWithFormat:@"IdleNotification%d", self.hash] object:nil];
	}
	return self;
}

-(void)handleNotification:(NSNotification *)notification {
	isIdle = YES;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	isIdle = NO;
	[[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:[NSString stringWithFormat:@"IdleNotification%d", self.hash] object:nil] postingStyle:NSPostWhenIdle];
	NSDate *start = [NSDate date];
	while ([start timeIntervalSinceNow] > (0 - 10)) {
		if (isIdle) {
			break;
		}
		CFRunLoopRunInMode(kCFRunLoopDefaultMode, .0001, false);
	}
	[super forwardInvocation:anInvocation];
}

@end
