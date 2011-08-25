//
//  UIView+ShelleyExtensions.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

@interface FORCELOAD_UIView_ShelleyExtensions @end 
@implementation FORCELOAD_UIView_ShelleyExtensions @end

@implementation UIView (ShelleyExtensions)

- (BOOL) marked:(NSString *)targetLabel{
	NSString *mark = [self accessibilityLabel];
	
    return mark && ([mark rangeOfString:targetLabel].location != NSNotFound);
}

- (BOOL) markedExactly:(NSString *)targetLabel{
    return [[self accessibilityLabel] isEqualToString:targetLabel];
}

@end
