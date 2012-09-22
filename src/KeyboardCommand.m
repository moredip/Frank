//
//  Created by pete on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KeyboardCommand.h"
#import "JSON.h"

#import <PublicAutomation/UIAutomationBridge.h>
#import "FranklyProtocolHelper.h"

@implementation KeyboardCommand {

}

- (NSString *)generateKeyboardNotPresentErrorResponse {
    return [FranklyProtocolHelper generateErrorResponseWithReason:@"keyboard not present"
                                                       andDetails:@"The iOS keyboard is not currently present, so Frank can't use it so simulate typing. You might want to simulate a tap on the thing you want to type into first."];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {

    NSDictionary *requestCommand = [requestBody JSONValue];
	NSString *textToType = [requestCommand objectForKey:@"text_to_type"];

    if( ![UIAutomationBridge checkForKeyboard] ){
        return [self generateKeyboardNotPresentErrorResponse];
    }
    
    [UIAutomationBridge typeIntoKeyboard:textToType];


	return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end