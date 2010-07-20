//
//  UserForm.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVO.h"

@protocol UserFormViewControllerDelegate

-(void)createUserSelected:(UserVO *)userVO;
-(void)updateUserSelected:(UserVO *)userVO;
-(void)userRolesSelected:(UserVO *)userVO;

@end

typedef enum {
	NEW, EDIT
} Mode;

@interface UserForm : UITableViewController {
	UserVO *userVO;
	UITextField *firstNameTextField, *lastNameTextField, *emailTextField, *usernameTextField, *passwordTextField, *confirmPasswordTextField;
	Mode mode;
	id<UserFormViewControllerDelegate> delegate;
}

@property(nonatomic, retain) UserVO *userVO;
@property(nonatomic, retain) UITextField *firstNameTextField, *lastNameTextField, *emailTextField, *usernameTextField, *passwordTextField, *confirmPasswordTextField;
@property Mode mode;
@property(nonatomic, retain) id<UserFormViewControllerDelegate> delegate;

-(UITextField *)textFieldWithPlaceHolder:(NSString *)placeHolder frame:(CGRect)frame;

@end
