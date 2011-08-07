//
//  UIQueryWebView.h
//  UISpec
//
//  Created by Cory Smith <cory.m.smith@gmail.com>
//  Copyright 2009 Assn. All rights reserved.
//

#import "UIQuery.h"

@interface UIQueryWebView : UIQuery {
	
}
-(UIQuery *)setValue:(NSString *)value forElementWithId:(NSString *)elementId;
-(UIQuery *)clickElementWithId:(NSString *)elementId;

-(UIQuery *)setValue:(NSString *)value forElementWithName:(NSString *)elementName;
-(UIQuery *)clickElementWithName:(NSString *)elementId;

-(NSString *)html;

@end
