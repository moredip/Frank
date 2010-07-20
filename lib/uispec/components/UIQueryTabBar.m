
#import "UIQueryTabBar.h"

@implementation UIQueryTabBar

-(UIQuery *)selectTabWithTitle:(NSString *)tabTitle {
	return [[[self.label text:tabTitle] parent] touch];
}

@end
