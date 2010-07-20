
#import "UIQueryExpectation.h"
#import "UIQuery.h"

@implementation UIQueryExpectation

+(id)withQuery:(UIQuery *)query {
	return [[[self alloc] initWithValue:&query objCType:@encode(id) file:"Please use expectThat() to get file and line number" line:-1 isFailureTest:NO] autorelease];
}

-(BOOL)exist {
	return [self exist:@""];
}

-(BOOL)exist:(NSString *)appendToFailureMessage {
	UIQuery *query = value;
	if ((([query views].count > 0) && isNot) || (([query views].count == 0) && !isNot)) {
		[NSException raise:nil format:@"%@ should %@ %@\n%s:%d", [query className], (isNot ? @"not exist" : @"exist"), appendToFailureMessage, file, line];
	}
	return YES;
}

-(NSString *)valueAsString {
	return NSStringFromClass([value class]);
}

-(void)be:(SEL)sel {
	UIQuery *query = value;
	NSMutableString *errorMessage = [NSMutableString string];
	for (UIView *view in [query targetViews]) {
		value = view;
		@try {
			[super be:sel];
		} @catch (NSException *exception) {
			[errorMessage appendFormat:exception.reason];
		}
	}
	value = query;
	if (errorMessage.length > 0) {
		[NSException raise:nil format:errorMessage];
	}
	
}

-(void)have:(NSInvocation *)invocation {
	UIQuery *query = value;
	NSMutableString *errorMessage = [NSMutableString string];
	for (UIView *view in [query targetViews]) {
		value = view;
		@try {
			[super have:invocation];
		} @catch (NSException *exception) {
			[errorMessage appendFormat:exception.reason];
		}
	}
	value = query;
	if (errorMessage.length > 0) {
		[NSException raise:nil format:errorMessage];
	}
}


@end
