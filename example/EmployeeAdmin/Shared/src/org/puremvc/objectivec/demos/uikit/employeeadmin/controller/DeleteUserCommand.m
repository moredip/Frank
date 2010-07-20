//
//  DeleteUserCommand.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "DeleteUserCommand.h"
#import "UserProxy.h"
#import "UserVO.h"

@implementation DeleteUserCommand

-(void)execute:(id<INotification>)notification {
	UserProxy *userProxy = (UserProxy *)[facade retrieveProxy:[UserProxy NAME]];
	UserVO *userVO = [notification body];
	[userProxy delete:userVO];
}

@end
