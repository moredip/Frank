
#import "CallCache.h"


@implementation CallCache

static NSMutableDictionary *fullCallCache;

+(NSMutableDictionary *)getFullCache {
	if (fullCallCache == nil) {
		fullCallCache = [[NSMutableDictionary dictionary] retain];
	} 
	return fullCallCache;
}

-(id)set:(id)object forSelector:(SEL)selector {
	return [self set:object for:NSStringFromSelector(selector)];
}

-(id)set:(id)object for:(id)key {
	NSMutableDictionary *myCallCache = [[CallCache getFullCache] objectForKey:[NSString stringWithFormat:@"%i", self.hash]];
	if (myCallCache == nil) {
		myCallCache = [NSMutableDictionary dictionary];
		[[CallCache getFullCache] setObject:myCallCache forKey:[NSString stringWithFormat:@"%i", self.hash]];
	}
	[myCallCache setObject:object forKey:key];
	return object;
}

-(id)getForSelector:(SEL)selector {
	return [self get:NSStringFromSelector(selector)];
}

-(id)get:(id)key {
	NSMutableDictionary *myCallCache = [[CallCache getFullCache] objectForKey:[NSString stringWithFormat:@"%i", self.hash]];
	if (myCallCache == nil) {
		return nil;
	}
	return [myCallCache objectForKey:key];
}

+(void)clear {
	[[CallCache getFullCache] removeAllObjects];
}

-(void)clear {
	[[CallCache getFullCache] removeAllObjects];
}

@end
