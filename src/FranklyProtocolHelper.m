//
//  Created by pete on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FranklyProtocolHelper.h"
#import "JSON.h"


@implementation FranklyProtocolHelper {

}

+ (NSString *)generateErrorResponseWithReason:(NSString *)reason andDetails:(NSString *)details{
	NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"ERROR", @"outcome",
							  reason, @"reason",
							  details, @"details",
							  nil];
	return [response JSONRepresentation];
}

+ (NSString *)generateSuccessResponseWithoutResults{
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:
    							  @"SUCCESS", @"outcome",
    							  nil];
    	return [response JSONRepresentation];
}

+ (NSString *)generateSuccessResponseWithResults:(NSArray *)results{
	NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"SUCCESS", @"outcome",
							  results, @"results",
							  nil];
	return [response JSONRepresentation];
}

@end