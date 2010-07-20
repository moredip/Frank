
#import "UIQuerySegmentedControl.h"


@implementation UIQuerySegmentedControl

-(UIQuery *)selectSegmentWithText:(NSString *)text {
	return [[self.label text:text] touch];
}

@end
