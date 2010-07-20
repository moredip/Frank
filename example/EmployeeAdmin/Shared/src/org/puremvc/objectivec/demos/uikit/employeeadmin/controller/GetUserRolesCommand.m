//
//  GetUserRolesCommand.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "GetUserRolesCommand.h"
#import "UserRolesProxy.h"
#import "ApplicationFacade.h"

@implementation GetUserRolesCommand

-(void)execute:(id<INotification>)notification {
	UserRolesProxy *userRolesProxy = (UserRolesProxy *)[facade retrieveProxy:[UserRolesProxy NAME]];
	[self sendNotification:GetUserRolesSuccess body:[userRolesProxy findByUsername:[notification body]]];
}

@end
