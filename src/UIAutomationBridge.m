//
//  UIAutomationBridge.m
//  Frank
//
//  Created by phodgson on 6/28/12.
//
//

#import "UIAutomationBridge.h"

#import "UIAutomation.h"

@implementation UIAutomationBridge


+ (BOOL) checkForKeyboard {
    // this was lifted from KIF's UIApplication+KIFAdditions
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if ([NSStringFromClass([window class]) isEqual:@"UITextEffectsWindow"]) {
            return YES;
        }
    }
    return NO;
}

+(void) typeIntoKeyboard:(NSString *)textToType{
    UIATarget *target = [UIATarget localTarget];
    UIAApplication *app = [target frontMostApp];
    UIAKeyboard *keyboard = [app keyboard];
    [keyboard typeString:textToType];
    
    
    
    // PREVIOUS KIF-BASED IMPLEMENTATION
    
    //    // this loop was lifted from [KIFTestStep stepToEnterText:intoViewWithAccessibilityLabel:traits:expectedResult:]
    //    for (NSUInteger characterIndex = 0; characterIndex < [textToType length]; characterIndex++) {
    //        NSString *characterString = [textToType substringWithRange:NSMakeRange(characterIndex, 1)];
    //
    //        if (![KIFTestStep _enterCharacter:characterString]) {
    //            return [self generateFailedToEnterCharacterErrorResponse:characterString];
    //        }
    //    }
}


@end
