//
//  SYArrayFilterTemplate.h
//  Shelley
//
//  Created by Pete Hodgson on 8/25/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYFilter.h"

@interface SYArrayFilterTemplate : NSObject<SYFilter> {
    
}

- (NSArray *) applyToView:(UIView *)view;

@end
