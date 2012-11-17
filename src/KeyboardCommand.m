//
//  Created by pete on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KeyboardCommand.h"
#import "JSON.h"

#if TARGET_OS_IPHONE
#import <PublicAutomation/UIAutomationBridge.h>
#endif

#import "FranklyProtocolHelper.h"

@implementation KeyboardCommand {

}

#if TARGET_OS_IPHONE
- (NSString *)generateKeyboardNotPresentErrorResponse {
    return [FranklyProtocolHelper generateErrorResponseWithReason:@"keyboard not present"
                                                       andDetails:@"The iOS keyboard is not currently present, so Frank can't use it so simulate typing. You might want to simulate a tap on the thing you want to type into first."];
}
#else
- (void) synthesizeNSEventForString:(NSString *)aString
{
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    
    if (keyWindow != nil)
    {
        NSEvent *event = [NSEvent keyEventWithType:NSKeyDown
                                          location:NSMakePoint(0, 0)
                                     modifierFlags:0
                                         timestamp:0
                                      windowNumber:[keyWindow windowNumber]
                                           context:nil
                                        characters:aString
                       charactersIgnoringModifiers:nil
                                         isARepeat:NO
                                           keyCode:0];
        
        [[NSApplication sharedApplication] postEvent:event atStart:NO];
        
        event = event = [NSEvent keyEventWithType:NSKeyUp
                                         location:NSMakePoint(0, 0)
                                    modifierFlags:0
                                        timestamp:0
                                     windowNumber:[keyWindow windowNumber]
                                          context:nil
                                       characters:aString
                      charactersIgnoringModifiers:nil
                                        isARepeat:NO
                                          keyCode:0];
        
        [[NSApplication sharedApplication] postEvent:event atStart:NO];
        
    }
}
#endif

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {

    NSDictionary *requestCommand = FROM_JSON(requestBody);
	NSString *textToType = [requestCommand objectForKey:@"text_to_type"];

#if TARGET_OS_IPHONE
    if( ![UIAutomationBridge checkForKeyboard] ){
        return [self generateKeyboardNotPresentErrorResponse];
    }
    
    [UIAutomationBridge typeIntoKeyboard:textToType];
#else
    [self synthesizeNSEventForString:textToType];
#endif


	return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end