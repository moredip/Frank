//
//  UIBug.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

@interface UIBug : UIImageView {

}

- (id)initWithPoint:(CGPoint)point;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)mySendEvent:(UIEvent *)anEvent;

+(id)bugAtPoint:(CGPoint)point;
+(id)console;
+(id)bugAtOriginalPoint;
+(id)unhighlight;
+(void)bringBugToFront;
+(void)removeKeyboardIfExists;
+(void)openInspectorWithView:(UIView *)view;
+(void)swizzleMethodOnClass:(Class)targetClass originalSelector:(SEL)originalSelector fromClass:(Class)fromClass alternateSelector:(SEL)alternateSelector;

@end
