//
//  UISwizzle.m
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

#import "UISwizzle.h"
#import "objc/runtime.h"
#import "UIParents.h"
#import "UIDescendants.h"
#import "UIChildren.h"

@implementation UISwizzle

static BOOL swizzleFiltersCalled;

+(void)swizzleFilters {
	if (!swizzleFiltersCalled) {
		swizzleFiltersCalled = YES;
		int i, propertyCount = 0;
		objc_property_t *propertyList = class_copyPropertyList([UISwizzle class], &propertyCount);
		for (i=0; i<propertyCount; i++) {
			objc_property_t *thisProperty = propertyList + i;
			const char* propertyName = property_getName(*thisProperty);
			NSString *key = [NSString stringWithFormat:@"%s", propertyName];
			class_addMethod([self class], NSSelectorFromString(key), method_getImplementation(class_getInstanceMethod([self class], @selector(templateFilter))), "@@:");
			class_addMethod([UIParents class], NSSelectorFromString(key), method_getImplementation(class_getInstanceMethod([self class], @selector(templateFilter))), "@@:");
			class_addMethod([UIDescendants class], NSSelectorFromString(key), method_getImplementation(class_getInstanceMethod([self class], @selector(templateFilter))), "@@:");
			class_addMethod([UIChildren class], NSSelectorFromString(key), method_getImplementation(class_getInstanceMethod([self class], @selector(templateFilter))), "@@:");
		}
	}
}


@end
