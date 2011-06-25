//
//  UIQuery.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//
#import "ViewFilterSwizzler.h"
#import "UIQueryExpectation.h"
#import "UITouchPerformer.h"

@class UIFilter;
@class UIRedoer;

UIQuery * $(NSMutableString *script, ...);

@interface UIQuery : ViewFilterSwizzler {
	UIQuery *first, *last, *all, *redo;
	UIFilter *with;
	UIQueryExpectation *should;
	UIQuery *parent, *child, *descendant, *find;
	UIQuery *touch, *show, *flash, *path, *inspect;
	NSMutableArray *views;
	NSString *className;
	UIRedoer *redoer;
	int timeout;
	BOOL filter, exists;
    
    UITouchPerformer *touchPerformer;
}

@property(nonatomic, readonly) UIFilter *with;
@property(nonatomic, readonly) UIQueryExpectation *should;
@property(nonatomic, readonly) UIQuery *parent, *child, *descendant, *find;
@property(nonatomic, readonly) UIQuery *touch, *flash, *show, *path, *inspect;
@property int timeout;
@property(nonatomic, retain) NSMutableArray *views;
@property(nonatomic, retain) NSString *className;
@property(nonatomic, retain) UIRedoer *redoer;
@property(nonatomic, readonly) UIQuery *first, *last, *all, *redo;
@property BOOL exists;

-(UIQuery *)find;
-(UIQuery *)descendant;
-(UIQuery *)child;
-(UIQuery *)parent;
-(UIQueryExpectation *)should;
-(UIFilter *)with;
-(id)initWithViews:(NSMutableArray *)_views className:(NSString *)_className filter:(BOOL)_filter;
-(NSArray *)collect:(NSArray *)views;
-(UIQuery *)target;
-(NSArray *)targetViews;
-(UIQuery *)timeout:(int)seconds;
-(id)templateFilter;
-(UIQuery *)index:(int)index;
-(UIQuery *)first;
-(UIQuery *)last;
-(UIQuery *)all;
-(UIQuery *)view:(NSString *)className;
-(UIQuery *)marked:(NSString *)mark;
-(UIQuery *)wait:(double)seconds;
-(id)redo;
-(BOOL)exists;
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
-(void)forwardInvocation:(NSInvocation *)anInvocation;
-(BOOL)respondsToSelector:(SEL)aSelector;
-(UIQuery *)flash;
-(UIQuery *)show;
-(UIQuery *)path;
-(UIQuery *)inspect;
-(NSString *)description;
-(void)logRange:(NSString *)prefix range:(NSRange)range;

// User event generation
// legacy
- (UIQuery *)touch;
- (UIQuery *)touchx:(NSNumber *)x y:(NSNumber *)y;
- (UIQuery *)touchxy:(NSNumber *)x ycoord:(NSNumber *)y;

//tapping
- (UIQuery *)tap;
- (UIQuery *)tapAtPoint: (NSString*) point;

// swiping
- (UIQuery *)swipeInDirection: (NSNumber *) direction;
- (UIQuery *)swipeAt: (NSString*) start direction: (NSNumber *) direction;
- (UIQuery *)swipeFrom: (NSString*) start to: (NSString*) end;

// pinch
- (UIQuery *) pinchFrom: (NSString *) start to: (NSString *) end;

+(id)withApplication;
+(NSDictionary *)describe:(id)object;
+(void)show:(NSArray *)views;
+(id)withViews:(NSMutableArray *)views className:(NSString *)className;
+(id)withViews:(NSMutableArray *)views className:(NSString *)className filter:(BOOL)filter;

@end

@interface UIView (UIQuery) 

@property(nonatomic, readonly) UIFilter *with;
@property(nonatomic, readonly) UIQueryExpectation *should;
@property(nonatomic, readonly) UIQuery *parent, *child, *descendant, *find;
@property(nonatomic, readonly) UIQuery *touch, *flash, *show, *path, *inspect;
@property int timeout;
@property(nonatomic, retain) NSMutableArray *views;
@property(nonatomic, retain) NSString *className;
@property(nonatomic, retain) UIRedoer *redoer;
@property(nonatomic, readonly) UIQuery *first, *last, *all, *redo;
@property BOOL exists;

-(UIQuery *)view:(NSString *)className;
-(UIQuery *)marked:(NSString *)mark;
-(UIQuery *)index:(int)index;
-(UIQuery *)timeout:(int)seconds;
-(UIQuery *)wait:(double)seconds;
-(UIQuery *)target;

@end