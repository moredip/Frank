//
//  SYFilter.h
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

@protocol SYFilter <NSObject>

- (NSArray *) applyToViews:(NSArray *)views;

@end