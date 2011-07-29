//
//  UIViewWithAccessibilityLabel.m
//  Shelley
//
//  Created by Pete Hodgson on 7/31/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "UIViewWithAccessibilityLabel.h"


@implementation UIViewWithAccessibilityLabel

- (id)initWithAccessibilityLabel:(NSString *)accessibilityLabel {
    self = [super init];
    if (self) {
        _accessibilityLabel = [accessibilityLabel retain];
    }
    return self;
}

- (void) setAccessibilityLabel:(NSString *)accessibilityLabel{
    [_accessibilityLabel release];
    _accessibilityLabel = [accessibilityLabel retain];
}

- (NSString *)accessibilityLabel{
    return _accessibilityLabel;
}

@end
