//
//  UIView+ShelleyExtensions.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(UIView_ShelleyExtensions)

@implementation UIView (ShelleyExtensions)

- (BOOL) marked:(NSString *)targetLabel{
	NSString *mark = [self accessibilityLabel];
	
    return mark && ([mark rangeOfString:targetLabel].location != NSNotFound);
}

- (BOOL) markedExactly:(NSString *)targetLabel{
    return [[self accessibilityLabel] isEqualToString:targetLabel];
}

@end
