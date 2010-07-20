//
//  GetUsersCommand.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//


#import "GetUsersCommand.h"
#import "ApplicationFacade.h"
#import "UserProxy.h"

@implementation GetUsersCommand

-(void)execute:(id<INotification>)notification {
	UserProxy *userProxy = (UserProxy *)[facade retrieveProxy:[UserProxy NAME]];
	[facade sendNotification:GetUsersSuccess body:userProxy.data];
}

@end
