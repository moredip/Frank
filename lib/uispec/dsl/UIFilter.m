#import "UIFilter.h"
#import "UIQuery.h"

@implementation UIFilter

@synthesize query, redoer;

+(id)withQuery:(UIQuery *)query {
	return [UIRedoer withTarget:[[[UIFilter alloc] initWithQuery:query] autorelease]];
}

-(id)initWithQuery:(UIQuery *)_query {
	if (self = [super init]) {
		self.query = _query;
	}
	return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	NSString *selector = NSStringFromSelector(aSelector);
	NSRange whereIsSet = [selector rangeOfString:@":"];
	if (whereIsSet.length != 0) {
		NSArray *selectors = [NSStringFromSelector(aSelector) componentsSeparatedByString:@":"];
		NSMutableString *signature = [NSMutableString stringWithString:@"@@:"];
		for (NSString *selector in selectors) {
			if ([selector length] > 0) {
				[signature appendString:@"@"];
			}
		}
		return [NSMethodSignature signatureWithObjCTypes:[signature cStringUsingEncoding:NSUTF8StringEncoding]];} 
	else {
		return [super methodSignatureForSelector:aSelector];
	}
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSMutableString *selector = [NSMutableString stringWithString:NSStringFromSelector([anInvocation selector])];
	NSArray *selectors = [selector componentsSeparatedByString:@":"];
	NSMutableArray *array = [NSMutableArray array];
	NSDate *start = [NSDate date];
	while ([start timeIntervalSinceNow] > (0 - [query timeout])) {
		for (UIView *view in [query views]) {
			int matchCount = 0;
			int i = 2;
			id value = nil;
			id resultValue = nil;
			for (NSString *key in selectors) {
				if (![key isEqualToString:@""]) {
					SEL selector = NSSelectorFromString(key);
					if (![view respondsToSelector:selector]) {
						continue;
					}
					[anInvocation getArgument:&value atIndex:i++];
					NSString *returnType = [NSString stringWithFormat:@"%s", [[view methodSignatureForSelector:selector] methodReturnType]];
					//NSLog(@"selector = %@ and returnType = %@", key, returnType);
					if ([returnType isEqualToString:@"@"]) {
						if ([value isKindOfClass:[NSString class]]) {
							if ([[view performSelector:selector] rangeOfString:value].length != 0) {
								matchCount++;
							}
						} else if ([[view performSelector:selector] isEqual:value]) {
							matchCount++;
						} else if ([view performSelector:selector] == value) {
							matchCount++;
						}
					} else {
						//if ([returnType isEqualToString:@"i"]) {
//							NSLog(@"value for int = %d and selector performed = %d", value, [view performSelector:selector]);
//						}
						if ([view performSelector:selector] == value) {
							matchCount++;
						}
					}
				} else {
					matchCount++;
				}
			}
			if (selectors.count == matchCount) {
				[array addObject:view];
			}
		}
		if (array.count > 0) {
			break;
		} else {
			//NSLog(@"selector = %@", selector);
			[self redo];
		}
	}
	id newQuery = [UIQuery withViews:array className:[query className]];
	[anInvocation setReturnValue:&newQuery];
}

-(id)redo {
	//NSLog(@"UIFilter Redo");
	if (redoer != nil) {
		//NSLog(@"UIFilter Redo redoer %@", redoer);
		UIRedoer *redone = [redoer redo];
		redoer.target = redone.target;
		self.query = [[redoer play] query];
	}
}

-(void)dealloc {
	self.query = nil;
	self.redoer = nil;
	[super dealloc];
}

@end
