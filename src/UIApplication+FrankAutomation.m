//
//  UIApplication+FrankAutomation.m
//  Frank
//
//  Created by Ondrej Hanslik on 9/15/13.
//
//

#import "UIApplication+FrankAutomation.h"
#import <objc/runtime.h>

static NSMutableArray* FEX_registeredWindows;

@interface UIWindow (FEX_WindowRegister)

@end

@implementation UIWindow (FEX_WindowRegister)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(initWithFrame:)),
                                   class_getInstanceMethod(self, @selector(FEX_initWithFrame:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self, @selector(FEX_dealloc)));
}

- (id)FEX_initWithFrame:(CGRect)frame {
    id instance = [self FEX_initWithFrame:frame];
    
    if (FEX_registeredWindows == nil) {
        CFArrayCallBacks callbacks;
        callbacks.version = 0;
        callbacks.retain = NULL;
        callbacks.release = NULL;
        callbacks.copyDescription = CFCopyDescription;
        callbacks.equal = CFEqual;
        
        CFMutableArrayRef arrayWithWeakReferences = CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
        FEX_registeredWindows = (NSMutableArray*) arrayWithWeakReferences;
    }
    
    [FEX_registeredWindows addObject:instance];
    
    return instance;
}

- (void)FEX_dealloc {
    [FEX_registeredWindows removeObject:self];
    
    [self FEX_dealloc];
}

@end

@implementation UIApplication (FrankAutomation)

- (NSArray*)FEX_windows {
    NSMutableArray* windows = [[[self windows] mutableCopy] autorelease];
    
    for (UIWindow* window in FEX_registeredWindows) {
        if (![windows containsObject:window]) {
            [windows addObject:window];
        }
    }
    
    NSComparisonResult (^levelComparator)(id, id) = ^NSComparisonResult(id obj1, id obj2) {
        UIWindow* window1 = obj1;
        UIWindow* window2 = obj2;
        
        if (window1.windowLevel < window2.windowLevel) {
            return NSOrderedAscending;
        }
        else if (window1.windowLevel < window2.windowLevel) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    };
    
    [windows sortWithOptions:NSSortStable
             usingComparator:levelComparator];
    
    return [[windows copy] autorelease];
}

@end

