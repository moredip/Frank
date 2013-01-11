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

- (void) synthesizeNSEventForString:(NSString *)aString
{
    NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
    
    if (mainWindow != nil)
    {
        for (NSUInteger charIndex = 0; charIndex < [aString length]; ++charIndex)
        {
            NSString* eventChar = [aString substringWithRange: NSMakeRange(charIndex, 1)];
            
            NSEvent *event = [NSEvent keyEventWithType:NSKeyDown
                                              location:NSMakePoint(0, 0)
                                         modifierFlags:0
                                             timestamp:0
                                          windowNumber:[mainWindow windowNumber]
                                               context:nil
                                            characters:eventChar
                           charactersIgnoringModifiers:nil
                                             isARepeat:NO
                                               keyCode:0];
            
            [[NSApplication sharedApplication] postEvent:event atStart:NO];
            
            event = event = [NSEvent keyEventWithType:NSKeyUp
                                             location:NSMakePoint(0, 0)
                                        modifierFlags:0
                                            timestamp:0
                                         windowNumber:[mainWindow windowNumber]
                                              context:nil
                                           characters:eventChar
                          charactersIgnoringModifiers:nil
                                            isARepeat:NO
                                              keyCode:0];
            
            [[NSApplication sharedApplication] postEvent:event atStart:NO];
        }
        
    }
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    
    NSDictionary *requestCommand = FROM_JSON(requestBody);
	NSString *textToType = [requestCommand objectForKey:@"text_to_type"];
    
    [self synthesizeNSEventForString:textToType];    
    
	return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end
