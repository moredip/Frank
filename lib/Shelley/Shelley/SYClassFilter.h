//
//  SYClassFilter.h
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYFilter.h"


@interface SYClassFilter : NSObject<SYFilter> {
    Class _targetClass;
}
@property (readonly) Class target;

- (id)initWithClass:(Class)class;

@end