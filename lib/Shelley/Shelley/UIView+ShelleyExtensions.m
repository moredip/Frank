//
//  UIView+ShelleyExtensions.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(UIView_ShelleyExtensions)

BOOL substringMatch(NSString *actualString, NSString *expectedSubstring){	
    return actualString && ([actualString rangeOfString:expectedSubstring].location != NSNotFound);    
}

@implementation UIView (ShelleyExtensions)

- (BOOL) marked:(NSString *)targetLabel{
    return substringMatch([self accessibilityLabel], targetLabel);
}

- (BOOL) markedExactly:(NSString *)targetLabel{
    return [[self accessibilityLabel] isEqualToString:targetLabel];
}

@end

@implementation UITextField (ShelleyExtensions)

- (BOOL) placeholder:(NSString *)expectedPlaceholder{
    return substringMatch([self placeholder], expectedPlaceholder);
}

- (BOOL) text:(NSString *)expectedText{
    return substringMatch([self text], expectedText);
}


@end

