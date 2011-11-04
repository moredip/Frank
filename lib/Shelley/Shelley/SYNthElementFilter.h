//
//  SYNthElementFilter.h
//  Shelley
//
//  Created by Pete Hodgson on 8/25/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYFilter.h"


@interface SYNthElementFilter : NSObject<SYFilter> {
    NSUInteger _index;
}

@property (readonly) NSUInteger index; 

- (id)initWithIndex:(NSUInteger)index;

@end
