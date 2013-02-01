//
//  VersionCommand.m
//  Frank
//
//  Created by Pete Hodgson on 1/31/13.
//
//

#import "VersionCommand.h"

@implementation VersionCommand {
    NSString *_version;
}

- (id)initWithVersion:(NSString *)version
{
    self = [super init];
    if (self) {
        _version = [version copy];
    }
    return self;
}

- (void)dealloc
{
    [_version release];
    [super dealloc];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    return [NSString stringWithFormat:@"{\"version\":\"%@\"}",_version];
}

@end