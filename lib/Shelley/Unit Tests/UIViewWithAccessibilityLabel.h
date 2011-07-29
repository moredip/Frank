//
//  UIViewWithAccessibilityLabel.h
//  Shelley
//
//  Created by Pete Hodgson on 7/31/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewWithAccessibilityLabel : UIView {
    NSString *_accessibilityLabel;
}
- (id)initWithAccessibilityLabel:(NSString *)accessibilityLabel;

@end
