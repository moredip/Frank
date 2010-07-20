//
//  EmployeeAdmin.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserList.h"
#import "UserForm.h"
#import "UserRoles.h"
#import "UserRolesVO.h"

@interface EmployeeAdmin : UIView {
	UINavigationController *navigation;
	UserList *userList;
	UserForm *userForm;
	UserRoles *userRoles;
}

@property(nonatomic, retain) UINavigationController *navigation;
@property(nonatomic, retain) UserList *userList;
@property(nonatomic, retain) UserForm *userForm;
@property(nonatomic, retain) UserRoles *userRoles;

-(void)showUserForm;
-(void)showUserList;
-(void)showUserRoles:(NSString *)username;
-(void)showError:(NSString *)message;
-(void)removeUserRoles;

@end
