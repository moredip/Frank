
#import "UILog.h"

@interface UIConsoleLog : NSObject <UILog> {
	NSDate *start;
	NSMutableArray *errors;
	NSString *currentExample;
	NSString *currentSpec;
}

@end
