//
//  Created by pete on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KeyboardCommand.h"
#import "JSON.h"


#import "KIFTestStep.h"
#import "FranklyProtocolHelper.h"
#import "UIApplication-KIFAdditions.h"

// KIF internal helpers which are not exposed but which we will be using none-the-less.
@interface KIFTestStep (Internals)
+ (BOOL)_enterCharacter:(NSString *)characterString;
@end


@implementation KeyboardCommand {

}

- (BOOL)checkForKeyboard {
 return nil != [[UIApplication sharedApplication] keyboardWindow];
}

- (NSString *)generateKeyboardNotPresentErrorResponse {
    return [FranklyProtocolHelper generateErrorResponseWithReason:@"keyboard not present"
                                                       andDetails:@"The iOS keyboard is not currently present, so Frank can't use it so simulate typing. You might want to simulate a tap on the thing you want to type into first."];
}

- (NSString *)generateFailedToEnterCharacterErrorResponse:(NSString *)characterWhichFailed {
    return [FranklyProtocolHelper generateErrorResponseWithReason:@"failed to type character"
                                                       andDetails:[NSString stringWithFormat:@"We were unable to type the character '%@'. This is probably because we couldn't find it on the keyboard. Please report this to the frank-discuss mailing list."]];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {

    NSDictionary *requestCommand = [requestBody JSONValue];
	NSString *textToType = [requestCommand objectForKey:@"text_to_type"];

    if( ![self checkForKeyboard] ){
        return [self generateKeyboardNotPresentErrorResponse];
    }

    // this loop was lifted from [KIFTestStep stepToEnterText:intoViewWithAccessibilityLabel:traits:expectedResult:]
    for (NSUInteger characterIndex = 0; characterIndex < [textToType length]; characterIndex++) {
        NSString *characterString = [textToType substringWithRange:NSMakeRange(characterIndex, 1)];

        if (![KIFTestStep _enterCharacter:characterString]) {
            return [self generateFailedToEnterCharacterErrorResponse:characterString];
        }
    }

	return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end