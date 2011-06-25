#import "UIExpectation.h"

@class UIQuery;

@interface UIQueryExpectation : UIExpectation {
}

-(BOOL)exist;
-(BOOL)exist:(NSString *)appendToFailureMessage ;
-(NSString *)valueAsString;
-(void)be:(SEL)sel;
-(void)have:(NSInvocation *)invocation;

+(id)withQuery:(UIQuery *)query;

@end
