
#import "UIQueryScrollView.h"


@implementation UIQueryScrollView

-(UIQuery *)scrollDown:(int)offset {
	UIScrollView *scroller = (UIScrollView *)self;
	[scroller setContentOffset:CGPointMake(0,offset) animated:NO];
	return [UIQuery withViews:views className:className];
}

-(UIQuery *)scrollToBottom {
	UIScrollView *scroller = (UIScrollView *)self;
	CGPoint bottomOffset = CGPointMake(0, [scroller contentSize].height);
	[scroller setContentOffset: bottomOffset animated: YES];
	return [UIQuery withViews:views className:className];
}

@end
