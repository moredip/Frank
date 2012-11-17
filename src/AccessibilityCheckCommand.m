//
//  AccessibilityCheckCommand.m
//  Chase iPad
//
//  Created by Pete Hodgson on 1/19/11.
//  Copyright 2011 ThoughtWorks. See NOTICE file for details.
//

#import "AccessibilityCheckCommand.h"
#import "JSON.h"

@implementation AccessibilityCheckCommand

#if TARGET_OS_IPHONE

- (BOOL) accessibilitySeemsToBeTurnedOn {
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	NSString *origAccessibilityLabel = [keyWindow accessibilityLabel];
	
	[keyWindow setAccessibilityLabel:@"TESTING ACCESSIBILITY"];
	BOOL setSucceeded = [[keyWindow accessibilityLabel] isEqualToString:@"TESTING ACCESSIBILITY"];
	
	[keyWindow setAccessibilityLabel:origAccessibilityLabel];
	
	return setSucceeded;
}

#else

- (BOOL) accessibilitySeemsToBeTurnedOn {
    return AXAPIEnabled();
}

#endif // TARGET_OS_IPHONE

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	NSString *boolString = ([self accessibilitySeemsToBeTurnedOn] ? @"true" : @"false");
	NSDictionary *response = [NSDictionary dictionaryWithObject:boolString
														forKey:@"accessibility_enabled"];
	return TO_JSON(response);
}

@end