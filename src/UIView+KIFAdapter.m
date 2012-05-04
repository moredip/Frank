//
//  UIView+KIFAdapter.m
//  Frank
//
//  Created by Pete Hodgson on 10/15/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "LoadableCategory.h"
#import "UIView-KIFAdditions.h"

MAKE_CATEGORIES_LOADABLE(UIView_KIFAdapter)

@implementation UIView(KIFAdapter) 

- (void)touch{
    NSLog(@"delegating to KIF's tap");
    [self tap];
}

- (void) touchx:(NSNumber *)x y:(NSNumber *)y {
    NSLog(@"delegating to KIF's tapAtPoint:");
    [self tapAtPoint:CGPointMake([x floatValue], [y floatValue])];
}
@end
