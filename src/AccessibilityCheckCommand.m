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

- (BOOL) accessibilitySeemsToBeTurnedOn {
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	NSString *origAccessibilityLabel = [keyWindow accessibilityLabel];
	
	[keyWindow setAccessibilityLabel:@"TESTING ACCESSIBILITY"];
	BOOL setSucceeded = [[keyWindow accessibilityLabel] isEqualToString:@"TESTING ACCESSIBILITY"];
	
	[keyWindow setAccessibilityLabel:origAccessibilityLabel];
	
	return setSucceeded;
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    __block NSDictionary* response = nil;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSString *boolString = ([self accessibilitySeemsToBeTurnedOn] ? @"true" : @"false");
        response = [[NSDictionary dictionaryWithObject:boolString forKey:@"accessibility_enabled"] retain];
    });
    
    [response autorelease];
    
	return [response JSONRepresentation];
}

@end