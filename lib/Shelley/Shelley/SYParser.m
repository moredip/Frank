//
//  SYParser.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParser.h"
#import "SYDescendants.h"
#import "SYParents.h"

@implementation SYParser

- (id)initWithSelectorString:(NSString *)selectorString {
    self = [super init];
    if (self) {
        _scanner = [[NSScanner alloc] initWithString:selectorString];
    }
    return self;
}

- (void)dealloc {
    [_scanner release];
    [super dealloc];
}

- (id<SYFilter>) nextFilter{
    NSString *filterString;
    if( ![_scanner scanUpToString:@" " intoString:&filterString] )
        return nil;
    
    if( [filterString isEqualToString:@"view"] ){
        return [[[SYDescendants alloc] init] autorelease];
    }else if( [filterString isEqualToString:@"parent"] ){
        return [[[SYParents alloc] init] autorelease];
    }
    
    [[NSException exceptionWithName:@"InvalidSelectorKeyword" 
                            reason:[NSString stringWithFormat:@"invalid selector keyword %@", filterString] 
                          userInfo:nil] raise];    
    return nil;
}

@end
