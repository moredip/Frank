//
//  SYClassFilter.h
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYArrayFilterTemplate.h"


@interface SYClassFilter : SYArrayFilterTemplate {
    Class _targetClass;
	BOOL _includeSelf;
    BOOL _justFilter;
}
@property (readonly) Class target;

- (id)initWithClass:(Class)class;
- (id)initWithClass:(Class)class includeSelf:(BOOL)includeSelf;

@end