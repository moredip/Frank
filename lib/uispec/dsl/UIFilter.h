//
//  UIFilter.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//
#import "UIRedoer.h"

@class UIQuery;

@interface UIFilter : NSObject {
	UIQuery *query, *redo;
	UIRedoer *redoer;
}

@property(nonatomic, retain) UIQuery *query;
@property(nonatomic, retain) UIRedoer *redoer;
@property(nonatomic, readonly) UIQuery *redo;

+(id)withQuery:(UIQuery *)query;

@end
