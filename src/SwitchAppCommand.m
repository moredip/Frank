//
//  SwitchAppCommand.m
//  Frank
//
//  Created by Pattapong
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwitchAppCommand.h"

@implementation SwitchAppCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    UIApplication *agentApplication = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:@"automationagent://"];
    if ([agentApplication canOpenURL:url]) {
        [agentApplication openURL:url];
        return @"{\"outcome\":\"SUCCESS\"}";
    }
    else {
        NSLog(@"The Receiver App is not installed. It must be installed to send text.");
        return @"{\"outcome\":\"FAILED\"}";
    }
}

@end
