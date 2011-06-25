//
//  UIRedoer.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//
#import "Recordable.h"

@interface UIRedoer : Recordable {
	UIRedoer *redo;
}

@property(nonatomic, readonly) UIRedoer *redo;
@end
