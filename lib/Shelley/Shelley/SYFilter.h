//
//  SYFilter.h
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYFilter <NSObject>

- (NSArray *) applyToView:(UIView *)view;

@end
