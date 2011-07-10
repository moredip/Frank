//
//  UIQueryTableView.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

#import "UIQueryScrollView.h"

@interface UIQueryTableView : UIQueryScrollView {

}

-(UIQuery *)scrollDown:(int)numberOfRows;
-(NSArray *)rowIndexPathList;

@end
