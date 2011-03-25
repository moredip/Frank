//
//  AccessibilityCheckCommand.m
//  Chase iPad
//
//  Created by Pete Hodgson on 1/19/11.
//  Copyright 2011 JPMorgan Chase. All rights reserved.
//

#import "AccessibilityCheckCommand.h"
#import "JSON.h"


@implementation AccessibilityCheckCommand

- (BOOL) accessibilitySeemsToBeTurnedOn {
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	NSString *origAccessibilityLabel = [keyWindow accessibilityLabel];
	
	[keyWindow setAccessibilityLabel:@"TESTING ACCESSIBILITY"];
	BOOL setSucceeded = [[keyWindow accessibilityLabel] isEqualToString:@"TESTING ACCESSIBILITY"];
	
	[keyWindow setAccessibilityLabel:origAccessibilityLabel];
	
	return setSucceeded;
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	NSString *boolString = ([self accessibilitySeemsToBeTurnedOn] ? @"true" : @"false");
	NSDictionary *response = [NSDictionary dictionaryWithObject:boolString
														forKey:@"accessibility_enabled"];
	return [response JSONRepresentation];
}

@end