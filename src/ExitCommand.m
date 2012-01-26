//
//  ExitCommand.m
//  Frank
//
//  Created by Martin Hauner on 26.09.10.
//  Copyright 2010 Martin Hauner. All rights reserved.
//

#import "ExitCommand.h"


@implementation ExitCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
  exit (0);
}

@end