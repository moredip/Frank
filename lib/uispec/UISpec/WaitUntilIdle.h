#import "UIProxy.h"

@interface WaitUntilIdle : UIProxy {
	NSInvocation *invocation;
	BOOL isIdle;
}

@property(nonatomic, retain) NSInvocation *invocation;

@end
