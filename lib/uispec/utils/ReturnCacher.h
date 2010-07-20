
#import "CallCache.h"
#import "UIProxy.h"

@interface ReturnCacher : UIProxy {
	CallCache *callCache;
}

@property(nonatomic, retain) CallCache *callCache;

@end
