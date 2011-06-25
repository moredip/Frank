//
//  UIQueryTableView.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

#import "UIQuery.h"

@interface UIQueryTableView : UIQuery {

}

-(UIQuery *)scrollToBottom;
-(UIQuery *)scrollDown:(int)numberOfRows;
-(NSArray *)rowIndexPathList;

@end
