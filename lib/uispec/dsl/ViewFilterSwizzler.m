
#import "ViewFilterSwizzler.h"
#import "objc/runtime.h"

@implementation ViewFilterSwizzler

+(void)initialize {
	[self swizzleFiltersForClass:[self class]];
}

+(void)swizzleFiltersForClass:(Class *)class {
	int i, propertyCount = 0;
	objc_property_t *propertyList = class_copyPropertyList([ViewFilterSwizzler class], &propertyCount);
	for (i=0; i<propertyCount; i++) {
		objc_property_t *thisProperty = propertyList + i;
		const char* propertyName = property_getName(*thisProperty);
		NSString *key = [NSString stringWithFormat:@"%s", propertyName];
		class_addMethod(class, NSSelectorFromString(key), method_getImplementation(class_getInstanceMethod(class, @selector(templateFilter))), "@@:");
	}
}

@end
