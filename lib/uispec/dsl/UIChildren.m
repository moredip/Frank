
#import "UIChildren.h"


@implementation UIChildren

+(id)withTraversal {
	return [[[self alloc] init] autorelease];
}

-(NSArray *)collect:(NSArray *)views {
	NSMutableArray *array = [NSMutableArray array];
	for (UIView *view in views) {
		for (UIView *subView in [view.subviews reverseObjectEnumerator]) {
			[array addObject:subView];
		}
	}
	return array;
}

@end
