//
//  SuccessCommand.m
//  Frank
//
//  Created by Buckley on 12/16/12.
//
//

#import "SuccessCommand.h"
#import "FranklyProtocolHelper.h"

@implementation SuccessCommand

- (NSString *) handleCommandWithRequestBody:(NSString *) requestBody {
	return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end
