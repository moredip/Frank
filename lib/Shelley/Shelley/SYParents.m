//
//  SYParents.m
//  Shelley
//
//  Created by Pete Hodgson on 7/20/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParents.h"


@implementation SYParents

-(NSArray *)applyToView:(UIView *)view{
    NSMutableArray *ancestors = [NSMutableArray array];

    UIView *currentView = view;
    while(( currentView = [currentView superview])){
        [ancestors addObject:currentView];
    }
    
    return ancestors;
}

- (BOOL) nextFilterShouldNotDescend {
    return YES;
}

@end
