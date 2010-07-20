//
//  UpdateUserRolesCommand.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UpdateUserRolesCommand.h"
#import "UserRolesProxy.h"
#import "ApplicationFacade.h"

@implementation UpdateUserRolesCommand

-(void)execute:(id<INotification>)notification {
	UserRolesProxy *userRolesProxy = (UserRolesProxy *)[facade retrieveProxy:[UserRolesProxy NAME]];
	[userRolesProxy update:[notification body]];
	[self sendNotification:RemoveUserRoles];
}

@end
