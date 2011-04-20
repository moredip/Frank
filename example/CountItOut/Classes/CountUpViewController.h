//
//  CountUpViewController.h
//  CountItOut
//
//  Created by Adam Schepis on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CountUpViewController : UITableViewController<UITextFieldDelegate> 
{
	NSManagedObjectContext *managedObjectContext;
	NSManagedObject *countUpObject;
	BOOL isNewObject;
	
	UITextField *textFieldGroup;
	UITextField *textFieldName;
	UITextField *textFieldMaxValue;
	UITextField *textFieldIncrement;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObject *countUpObject;

-(void) save:(id) sender;

// UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;


@end
