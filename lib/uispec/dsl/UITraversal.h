#import "UISwizzle.h"
#import "UIRedoer.h"

@class UIQuery;

@interface UITraversal : UISwizzle {
	NSMutableArray *views;
	NSString *className;
	UIRedoer *redoer;
	int timeout;
	UIQuery *first, *last, *all, *redo;
}

@property int timeout;
@property(nonatomic, retain) NSMutableArray *views;
@property(nonatomic, retain) NSString *className;
@property(nonatomic, retain) UIRedoer *redoer;
@property(nonatomic, readonly) UIQuery *first, *last, *all, *redo;

-(UIQuery *)view:(NSString *)className;
-(UIQuery *)index:(int)index;
-(UIQuery *)timeout:(int)seconds;
-(UIQuery *)wait:(double)seconds;

@end
