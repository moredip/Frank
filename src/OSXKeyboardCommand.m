//
//  OSXKeyboardCommand.m
//  Frank
//
//  Created by Buckley on 11/20/12.
//
//

#import "OSXKeyboardCommand.h"
#import "JSON.h"
#import "FranklyProtocolHelper.h"

@implementation OSXKeyboardCommand

- (void) synthesizeNSEventForString: (NSString*) aString modifiers: (NSUInteger) modifiers
{
    for (NSUInteger charIndex = 0; charIndex < [aString length]; ++charIndex)
    {
        NSString* eventChar = [aString substringWithRange: NSMakeRange(charIndex, 1)];
        
        NSEvent *event = [NSEvent keyEventWithType:NSKeyDown
                                          location:NSMakePoint(0, 0)
                                     modifierFlags:modifiers
                                         timestamp:0
                                      windowNumber:0
                                           context:nil
                                        characters:eventChar
                       charactersIgnoringModifiers:eventChar
                                         isARepeat:NO
                                           keyCode:0];
        
        [[NSApplication sharedApplication] postEvent:event atStart:NO];
        
        event = event = [NSEvent keyEventWithType:NSKeyUp
                                         location:NSMakePoint(0, 0)
                                    modifierFlags:modifiers
                                        timestamp:0
                                     windowNumber:0
                                          context:nil
                                       characters:eventChar
                      charactersIgnoringModifiers:eventChar
                                        isARepeat:NO
                                          keyCode:0];
        
        [[NSApplication sharedApplication] postEvent:event atStart:NO];
    }
}

- (NSString *)handleCommandWithRequestBody: (NSString*) requestBody {
    
    NSDictionary *requestCommand = FROM_JSON(requestBody);
	NSString *textToType = [requestCommand objectForKey:@"text_to_type"];
    NSDictionary* modifiers = [requestCommand objectForKey:@"modifiers"];
    NSUInteger modifierFlags = 0;
    
    for (NSString* modifier in modifiers)
    {
        modifier = [modifier lowercaseString];
        
        if ([modifier isEqual: @"command"] || [modifier isEqual: @"cmd"])
        {
            modifierFlags |= NSCommandKeyMask;
        }
        if ([modifier isEqual: @"shift"])
        {
            modifierFlags |= NSShiftKeyMask;
        }
        if ([modifier isEqual: @"option"] || [modifier isEqual: @"alt"] )
        {
            modifierFlags |= NSAlternateKeyMask;
        }
        if ([modifier isEqual: @"control"] || [modifier isEqual: @"ctrl"])
        {
            modifierFlags |= NSControlKeyMask;
        }
    }
    
    [self synthesizeNSEventForString: textToType modifiers: modifierFlags];
    
	return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end
