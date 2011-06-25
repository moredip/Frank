//
//  UIInspector.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//
#import "UIQuery.h"

#define typeof __typeof__
#define NSValueMake(variable) [NSValue value:&variable withObjCType:@encode(typeof(variable))]

@interface UIInspector : UITableViewController {
	UIView *targetView;
	NSMutableDictionary *properties;
	NSArray *targetSubviews;
}

@property(nonatomic, retain) UIView *targetView;
@property(nonatomic, retain) NSMutableDictionary *properties;
@property(nonatomic, retain) NSArray *targetSubviews;

+(void)setInBrowserMode:(BOOL)yesOrNo;
+(BOOL)inBrowserMode;

@end
