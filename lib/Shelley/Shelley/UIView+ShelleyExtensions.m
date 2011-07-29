//
//  UIView+ShelleyExtensions.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "UIView+ShelleyExtensions.h"


@implementation UIView (ShelleyExtensions)

- (BOOL) marked:(NSString *)targetLabel{
    return [[self accessibilityLabel] isEqualToString:targetLabel];
}

@end
