//
//  SYArrayFilterTemplate.m
//  Shelley
//
//  Created by Pete Hodgson on 8/25/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYArrayFilterTemplate.h"


@implementation SYArrayFilterTemplate

// hook method, must be implemented by concrete subclass
- (NSArray *) applyToView:(UIView *)view {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSArray *) applyToViews:(NSArray *)views {
    NSMutableArray *filteredViews = [NSMutableArray array];
    for (UIView *view in views) {
        [filteredViews addObjectsFromArray:[self applyToView:view]];
    }    
    return filteredViews;
}

@end
