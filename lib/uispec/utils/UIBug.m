
#import "UIBug.h"
#import "objc/runtime.h"
#import "UIInspector.h"
#import "UIConsole.h"

@implementation UIBug

static BOOL swizzleWasDone = NO;

static UIBug *bug = nil;

static UIConsole *console = nil;

static CGPoint originalPoint;

+(id)bugAtPoint:(CGPoint)point {
	if (bug == nil) {
		bug = [[UIBug alloc] initWithPoint:point];
		originalPoint = point;
	} else {
		bug.frame = CGRectMake(point.x, point.y, bug.frame.size.width, bug.frame.size.height);
	}
	return bug;
}

+(id)console {
	if (console == nil) {
		console = [[UIConsole alloc] init];
	}
	return console;
}

+(id)bugAtOriginalPoint {
	return [self bugAtPoint:originalPoint];
}

+(id)unhighlight {
	bug.highlighted = NO;
}

+(void)bringBugToFront {
	//NSLog(@"bring bug to front");
	[[UIApplication sharedApplication].keyWindow addSubview:[self bugAtOriginalPoint]];
	
	for (UIView *windows in [UIApplication sharedApplication].windows) {
		for (UIView *view in windows.subviews) {
			if ([NSStringFromClass([view class]) isEqualToString:@"UIKeyboard"]) {
				[view addSubview:[self bugAtPoint:CGPointMake(0,200)]];
				continue;
			}
			for (UIView *subview in view.subviews) {
				if ([NSStringFromClass([subview class]) isEqualToString:@"UIActionSheet"]) {
					[subview addSubview:[self bugAtPoint:CGPointMake(0,245)]];
				}
			}
		}
	}
}

- (id)initWithPoint:(CGPoint)point {
	if (!swizzleWasDone) {
		[UIBug swizzleMethodOnClass:[UIApplication class] originalSelector:@selector(sendEvent:) fromClass:[UIBug class] alternateSelector:@selector(mySendEvent:)];
		swizzleWasDone = YES;
	}
	if (self = [super initWithImage:[UIImage imageNamed:@"UISpec.bundle/images/uibug.png"] highlightedImage:[UIImage imageNamed:@"UISpec.bundle/images/uibug2.png"]]) {
		self.userInteractionEnabled = YES;
		self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UIActionSheet	*actionSheet = [[[UIActionSheet alloc] initWithTitle:nil 
															  delegate:self cancelButtonTitle:@"Cancel" 
                                                destructiveButtonTitle:nil 
													 otherButtonTitles:@"Open Console", 
                                     @"Enable Inspector", nil] autorelease];
    UIApplication *application = [[UIApplication sharedApplication] delegate];
    [actionSheet showInView:[application window]];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0: {
			[[UIApplication sharedApplication].keyWindow addSubview:[UIBug console]];
            break;
		}
		case 1: {
            self.highlighted = YES;
			[UIInspector setInBrowserMode:NO];
            break;
		}
	}
}

+(void)removeKeyboardIfExists {
	for (UIView *windows in [UIApplication sharedApplication].windows) {
		for (UIView *view in windows.subviews) {
			if ([NSStringFromClass([view class]) isEqualToString:@"UIKeyboard"]) {
				[view removeFromSuperview];
			}
		}
	}
}

+(void)openInspectorWithView:(UIView *)view {
	[UIBug removeKeyboardIfExists];
	
	//[[UIQuery withViews:[NSArray arrayWithObject:touch.view] className:NSStringFromClass([touch.view class])] descendant].all.show;
	//NSLog(@"pushing view %@", targetView);
	//UINavigationController *nav = [[[UIQuery withApplication] view:@"UILayoutContainerView"].last delegate];
	UIInspector *browser = [[[UIInspector alloc] initWithView:view] autorelease];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
	//NSLog(@"pushing view %@", targetView);
	nav.view.backgroundColor = [UIColor whiteColor];
	[[UIApplication sharedApplication].keyWindow addSubview:nav.view];
	[UIInspector setInBrowserMode:YES];
}

- (void)mySendEvent:(UIEvent *)anEvent {
	NSArray *allTouches = [[anEvent allTouches] allObjects];
	if (anEvent.type == UIEventTypeTouches && allTouches.count > 0 && ![UIInspector inBrowserMode]) {
		//NSLog(@"event = %@", anEvent);
		for (UITouch *touch in allTouches) {
			if (touch.phase == UITouchPhaseBegan) {
				UIView *targetView = touch.view;
				[UIBug openInspectorWithView:targetView];
			}
		}
	} else {
		[[UIApplication sharedApplication] mySendEvent:anEvent];
	}
	[UIBug bringBugToFront];
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
		class_addMethod(targetClass, alternateSelector, alternateImplementation, "@@:@");
		alternateMethod = class_getInstanceMethod(targetClass, alternateSelector);
		method_setImplementation(originalMethod, alternateImplementation);
		method_setImplementation(alternateMethod, originalImplementation);
	}
}



@end
