#import "UISpec.h"
#import "objc/runtime.h"
#import "UIConsoleLog.h"

@implementation UISpec

static UILog *logger = nil;

+(void)initialize {
	logger = [[UIConsoleLog alloc] init];
}

+(void)setLog:(UILog *)log{
	[logger release];
	logger = [log retain];
}

+(void)runSpecsAfterDelay:(int)seconds {
	[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(runSpecs) userInfo:nil repeats:NO];
}

+(void)runSpec:(NSString *)specName afterDelay:(int)seconds {
	[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(runSpec:) userInfo:specName repeats:NO];
}

+(void)runSpec:(NSString *)specName example:(NSString *)exampleName afterDelay:(int)seconds {
	[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(runSpecExample:) userInfo:[NSArray arrayWithObjects:specName, exampleName, nil] repeats:NO];
}

+(void)runSpecs {
	NSArray *specClasses = [self specClasses];
	[self runSpecClasses:specClasses];
}

+(void)runSpec:(NSTimer *)timer {
	Class class = NSClassFromString(timer.userInfo);
	[self runSpecClasses:[NSArray arrayWithObject:class]];
}

+(void)runSpecExample:(NSTimer *)timer {
	Class class = NSClassFromString([timer.userInfo objectAtIndex:0]);
	NSString *exampleName = [timer.userInfo objectAtIndex:1];
	[logger onStart];
	[self runExamples:[NSArray arrayWithObject:exampleName] onSpec:class];
	[logger onFinish:1];
}

+(void)runSpecClasses:(NSArray *)specClasses {
	if (specClasses.count == 0) return;
	int examplesCount = 0;
	[logger onStart];
	for (Class class in specClasses) {
		NSArray *examples = [self examplesForSpecClass:class];
		if (examples.count == 0) continue;
		examplesCount = examplesCount + examples.count;
		[self runExamples:examples onSpec:class];
	}
	[logger onFinish:examplesCount];
}

+(void)runExamples:(NSArray *)examples onSpec:(Class)class {
	UISpec *spec = [[[class alloc] init] autorelease];
	[logger onSpec:spec];
	if ([spec respondsToSelector:@selector(beforeAll)]) {
		@try {
			[logger onBeforeAll];
			[spec beforeAll];
		} @catch (NSException *exception) {
			[logger onBeforeAllException:exception];
		}
	}
	for (NSString *exampleName in [examples reverseObjectEnumerator]) {
		if ([spec respondsToSelector:@selector(before)]) {
			@try {
				[logger onBefore:exampleName];
				[spec before];
			} @catch (NSException *exception) {
				[logger onBeforeException:exception];
			}
		}
		@try {
			[logger onExample:exampleName];
			[spec performSelector:NSSelectorFromString(exampleName)];
		} @catch (NSException *exception) {
			[logger onExampleException:exception];
		}
		if ([spec respondsToSelector:@selector(after)]) {
			@try {
				[logger onAfter:exampleName];
				[spec after];
			} @catch (NSException *exception) {
				[logger onAfterException:exception];
			}
		}
	}
	if ([spec respondsToSelector:@selector(afterAll)]) {
		@try {
			[logger onAfterAll];
			[spec afterAll];
		} @catch (NSException *exception) {
			[logger onAfterAllException:exception];
		}
	}
	[logger afterSpec:spec];
}

+(NSDictionary *)specsAndExamples {
	NSArray *specClasses = [self specClasses];
	NSMutableDictionary *specsAndExamples = [NSMutableDictionary dictionaryWithCapacity:[specClasses count]];
	for (Class specClass in specClasses) {
		NSArray *examples = [self examplesForSpecClass:specClass];
		if ([examples count]) {
			[specsAndExamples addObject:examples forKey:NSStringFromClass(specClass)];
		}
	}
	return specsAndExamples;
}

+(NSArray *)examplesForSpecClass:(Class)specClass {
	NSMutableArray *array = [NSMutableArray array];
	unsigned int methodCount;
	Method *methods = class_copyMethodList(specClass, &methodCount);
	for (size_t i = 0; i < methodCount; ++i) {
		Method method = methods[i];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
		if ([selectorName hasPrefix:@"it"]) {
			[array addObject:selectorName];
		}
	}
	return array;
}

+(BOOL)isASpec:(Class)class {
	//Class spec = NSClassFromString(@"UISpec");
	while (class) {
		if (class_conformsToProtocol(class, NSProtocolFromString(@"UISpec"))) {
			return YES;
		}
		class = class_getSuperclass(class);
	}
	return NO;
}

+(NSArray*)specClasses {
	NSMutableArray *array = [NSMutableArray array];
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        Class *classes = malloc(sizeof(Class) * numClasses);
        (void) objc_getClassList (classes, numClasses);
        int i;
        for (i = 0; i < numClasses; i++) {
            Class c = classes[i];
			if ([self isASpec:c]) {
				[array addObject:c];
			}
        }
        free(classes);
    }
	return array;
}

+(void)swizzleMethodOnClass:(Class)targetClass originalSelector:(SEL)originalSelector fromClass:(Class)fromClass alternateSelector:(SEL)alternateSelector {
    Method originalMethod = nil, alternateMethod = nil;
	
    // First, look for the methods
    originalMethod = class_getInstanceMethod(targetClass, originalSelector);
    alternateMethod = class_getInstanceMethod(fromClass, alternateSelector);
    
    // If both are found, swizzle them
    if (originalMethod != nil && alternateMethod != nil) {
		IMP originalImplementation = method_getImplementation(originalMethod);
		IMP alternateImplementation = method_getImplementation(alternateMethod);
		method_setImplementation(originalMethod, alternateImplementation);
		method_setImplementation(alternateMethod, originalImplementation);
	}
}

@end