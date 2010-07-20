//
//  ApplicationFacade.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facade.h"

#define Startup @"Startup"
#define ShowNewUser @"ShowNewUser"
#define ShowEditUser @"ShowEditUser"
#define ShowUserForm @"ShowUserForm"
#define ShowUserList @"ShowUserList"
#define	ShowUserRoles @"ShowUserRoles"
#define RemoveUserRoles @"RemoveUserRoles"
#define ShowError @"ShowError"
#define CreateUser @"CreateUser"
#define UpdateUser @"UpdateUser"
#define DeleteUser @"DeleteUser"
#define GetUsers @"GetUsers"
#define GetUsersSuccess @"GetUsersSuccess"
#define GetUserRoles @"GetUserRoles"
#define GetUserRolesSuccess @"GetUserRolesSuccess"
#define UpdateUserRoles @"UpdateUserRoles"

@interface ApplicationFacade : Facade {
}

+(ApplicationFacade *)getInstance;

-(void)startup:(id)app;

@end
