//
//  UserListMediator.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserListMediator.h"

@implementation UserListMediator

+(NSString *)NAME {
	return @"UserListMediator";
}

-(UserList *)viewComponent {
	return viewComponent;
}

-(void)initializeMediator {
	self.mediatorName = [UserListMediator NAME];
}

-(void)onRegister {
	[self.viewComponent setDelegate:self];
}

-(NSArray *)listNotificationInterests {
	return [NSArray arrayWithObjects:GetUsersSuccess, nil];
}

-(void)handleNotification:(id<INotification>)notification {
	if ([[notification name] isEqualToString:GetUsersSuccess]) {
		[self.viewComponent reloadUsers:[notification body]];
	}
}

-(void)userListAppeared {
	[self sendNotification:GetUsers];
}

-(void)userSelected:(UserVO *)userVO {
	[self sendNotification:ShowEditUser body:userVO];
}

-(void)deleteUserSelected:(UserVO *)userVO {
	[self sendNotification:DeleteUser body:userVO];
}

-(void)newUserSelected {
	[self sendNotification:ShowNewUser];
}

-(void)dealloc {
	[super dealloc];
}

@end
