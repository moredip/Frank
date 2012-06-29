//
//  UIAutomationBridge.h
//  Frank
//
//  Created by phodgson on 6/28/12.
//
//

#import <Foundation/Foundation.h>

@interface UIAutomationBridge : NSObject

+ (BOOL) checkForKeyboard;
+ (void) typeIntoKeyboard:(NSString *)string;

@end
