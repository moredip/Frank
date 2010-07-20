#import "UIExpectation.h"

@class UIQuery;

@interface UIQueryExpectation : UIExpectation {
}

+(id)withQuery:(UIQuery *)query;

@end
