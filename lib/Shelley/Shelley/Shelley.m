//
//  Shelley.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "Shelley.h"


@implementation Shelley

+ (Shelley *) withSelectorString:(NSString *)selectorString
{
    // TODO
    return [[[self alloc] init] autorelease];
}

- (NSArray *) selectFrom:(UIView *)rootView
{
    return [rootView subviews];
//    return [rootView.subviews subarrayWithRange:NSRangeFromString(@"0 1")];
}

@end
