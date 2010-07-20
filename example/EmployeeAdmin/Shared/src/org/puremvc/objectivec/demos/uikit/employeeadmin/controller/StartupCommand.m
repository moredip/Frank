//
//  StartupCommand.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "StartupCommand.h"
#import "EmployeeAdmin.h"
#import "ApplicationFacade.h"
#import "UserListMediator.h"
#import "UserProxy.h"
#import "UserFormMediator.h"
#import "EmployeeAdminMediator.h"
#import "UserRolesProxy.h"
#import "UserRolesMediator.h"

@implementation StartupCommand

-(void)execute:(id<INotification>)notification {
	[facade registerProxy:[UserProxy proxy]];
	[facade registerProxy:[UserRolesProxy proxy]];
	
	EmployeeAdmin *app = [notification body];
	
	[facade registerMediator:[EmployeeAdminMediator withViewComponent:app]];
	[facade registerMediator:[UserListMediator withViewComponent:app.userList]];
	[facade registerMediator:[UserFormMediator withViewComponent:app.userForm]];
	[facade registerMediator:[UserRolesMediator withViewComponent:app.userRoles]];
}

@end
