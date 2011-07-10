
#import "ViewFilterSwizzler.h"
#import "objc/runtime.h"

@implementation ViewFilterSwizzler

@synthesize textField;
@synthesize navigationBar;
@synthesize label;
@synthesize button;
@synthesize navigationButton;
@synthesize alertView;
@synthesize textView;
@synthesize tableView;
@synthesize tableViewCell;
@synthesize toolbar;
@synthesize toolbarButton;
@synthesize tabBar;
@synthesize tabBarButton;
@synthesize datePicker;
@synthesize window;
@synthesize webView;
@synthesize view;
@synthesize Switch;
@synthesize slider;
@synthesize segmentedControl;
@synthesize searchBar;
@synthesize scrollView;
@synthesize progressView;
@synthesize pickerView;
@synthesize pageControl;
@synthesize imageView;
@synthesize control;
@synthesize actionSheet;
@synthesize activityIndicatorView;
@synthesize threePartButton;
@synthesize navigationItemButtonView;
@synthesize navigationItemView;
@synthesize removeControlMinusButton;
@synthesize pushButton;

+(void)initialize {
	[self swizzleFiltersForClass:[self class]];
}

+(void)swizzleFiltersForClass:(Class)class {
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
