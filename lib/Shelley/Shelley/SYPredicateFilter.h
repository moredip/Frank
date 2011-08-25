//
//  SYPredicateFilter.h
//  Shelley
//
//  Created by Pete Hodgson on 7/20/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYArrayFilterTemplate.h"

@interface SYPredicateFilter : SYArrayFilterTemplate {
    SEL _selector;
    NSArray *_args;
    
}
@property (readonly) SEL selector;
@property (readonly) NSArray *args;

- (id)initWithSelector:(SEL)selector args:(NSArray *)args;

@end
