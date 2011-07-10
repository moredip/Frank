
#import "UIQueryScrollView.h"


@implementation UIQueryScrollView

-(UIQuery*)scrollToTop {
    UIScrollView *scroller = (UIScrollView *)self;
	[scroller setContentOffset:CGPointMake(0, 0) animated:YES];
	return [UIQuery withViews:views className:className];
}

-(UIQuery *)scrollDown:(int)offset {
	UIScrollView *scroller = (UIScrollView *)self;
	[scroller setContentOffset:CGPointMake(0,offset) animated:NO];
	return [UIQuery withViews:views className:className];
}

-(UIQuery *)scrollToBottom {
	UIScrollView *scroller = (UIScrollView *)self;
    CGFloat scrollerSize = scroller.contentSize.height;
    CGFloat offset = scrollerSize - scroller.frame.size.height;
	CGPoint bottomOrigin = CGPointMake(0, offset);
	[scroller setContentOffset: bottomOrigin animated: YES];
	return [UIQuery withViews:views className:className];
}

@end
