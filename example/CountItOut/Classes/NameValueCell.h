//
//  NameValueCell.h
//
//  Created by Adam Schepis on 9/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NameValueCell :  UITableViewCell
{
	IBOutlet UILabel *name;
	IBOutlet UITextField *value;
}

@property(nonatomic, retain) IBOutlet UILabel *name;
@property(nonatomic, retain) IBOutlet UITextField *value;

@end
