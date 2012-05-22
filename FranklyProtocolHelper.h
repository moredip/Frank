//
//  Created by pete on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface FranklyProtocolHelper : NSObject
+ (NSString *)generateErrorResponseWithReason:(NSString *)reason andDetails:(NSString *)details;

+ (NSString *)generateSuccessResponseWithoutResults;

+ (NSString *)generateSuccessResponseWithResults:(NSArray *)results;


@end