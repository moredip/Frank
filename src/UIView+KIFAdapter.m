//
//  UIView+KIFAdapter.m
//  Frank
//
//  Created by Pete Hodgson on 10/15/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "LoadableCategory.h"
#import "UIView-KIFAdditions.h"

#import <objc/runtime.h>

MAKE_CATEGORIES_LOADABLE(UIView_KIFAdapter)

@implementation UIView(KIFAdapter)

- (BOOL) touchPointIfInsideWindow:(CGPoint)point{
    
    Class eventsKlass = NSClassFromString(@"UIASyntheticEvents");
    id events = class_createInstance(eventsKlass, 0);

    uint numMethods = 0;
    Method *methods = class_copyMethodList(eventsKlass, &numMethods);
    for( int i = 0; i< numMethods; i++ ){
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSLog( @"%@", NSStringFromSelector(sel) );
    }

    CGPoint pointInWindowCoords = [self.window convertPoint:point fromView:self];
    if( !CGRectContainsPoint(self.window.bounds, pointInWindowCoords) ){
        return NO;
    }
    
    
    [events sendTap:pointInWindowCoords];

    // delegate to KIF
//    [self tapAtPoint:point];
    return YES;
}

- (BOOL)touch{
    CGPoint centerPoint = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    return [self touchPointIfInsideWindow:centerPoint];
}

- (BOOL) touchx:(NSNumber *)x y:(NSNumber *)y {
    return [self touchPointIfInsideWindow:CGPointMake([x floatValue], [y floatValue])];
}

@end