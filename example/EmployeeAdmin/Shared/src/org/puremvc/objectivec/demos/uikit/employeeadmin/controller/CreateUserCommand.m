//
//  CreateUserCommand.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "CreateUserCommand.h"
#import "ApplicationFacade.h"
#import "UserProxy.h"
#import "UserVO.h"

@implementation CreateUserCommand

-(void)execute:(id<INotification>)notification {
	UserProxy *userProxy = (UserProxy *)[facade retrieveProxy:[UserProxy NAME]];
	UserVO *userVO = [notification body];
	if ([userVO isValid]) {
		[userProxy create:userVO];
		[facade sendNotification:ShowUserList];
	} else {
		[facade sendNotification:ShowError body:@"Invalid User"];
	}
}

@end
