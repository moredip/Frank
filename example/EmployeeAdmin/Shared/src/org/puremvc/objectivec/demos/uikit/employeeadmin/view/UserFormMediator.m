//
//  UserFormMediator.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserFormMediator.h"

@implementation UserFormMediator

+(NSString *)NAME {
	return @"UserFormMediator";
}

-(UserForm *)viewComponent {
	return viewComponent;
}

-(void)initializeMediator {
	self.mediatorName = [UserFormMediator NAME];
}

-(void)onRegister {
	[self.viewComponent setDelegate:self];
}

-(NSArray *)listNotificationInterests {
	return [NSArray arrayWithObjects:ShowEditUser, ShowNewUser, nil];
}

-(void)createUserSelected:(UserVO *)userVO {
	[self sendNotification:CreateUser body:userVO];
}

-(void)updateUserSelected:(UserVO *)userVO {
	[self sendNotification:UpdateUser body:userVO];
}

-(void)userRolesSelected:(UserVO *)userVO {
	[self sendNotification:ShowUserRoles body:userVO.username];
}

-(void)handleNotification:(id<INotification>)notification {
	[self.viewComponent setView:nil];
	if ([[notification name] isEqualToString:ShowEditUser]) {
		[self.viewComponent setUserVO:[notification body]];
		[self.viewComponent setMode:EDIT];
	} else if ([[notification name] isEqualToString:ShowNewUser]) {
		[self.viewComponent setUserVO:[[[UserVO alloc] init] autorelease]];
		[self.viewComponent setMode:NEW];
	}
	[self sendNotification:ShowUserForm body:self.viewComponent];
}

-(void)dealloc {
	[super dealloc];
}

@end
