//
//  FrankApplication.m
//  Frank
//
//  Created by Oleksiy Radyvanyuk on 9/29/13.
//
//

#import "FrankApplication.h"
#if TARGET_OS_IPHONE
#include "UIApplication+FrankAutomation.h"
#else
#include "NSApplication+FrankAutomation.h"
#endif

@implementation FrankApplication

- (NSArray *)windows {
#if TARGET_OS_IPHONE
    return [[UIApplication sharedApplication] FEX_windows];
#else
    return @[[NSApplication sharedApplication]];
#endif
}

@end
