//
//  UserRolesMediator.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserRolesMediator.h"
#import "ApplicationFacade.h"

@implementation UserRolesMediator

+(NSString *)NAME {
	return @"UserRolesMediator";
}

-(UserRoles *)viewComponent {
	return viewComponent;
}

-(void)initializeMediator {
	self.mediatorName = [UserRolesMediator NAME];
}

-(void)onRegister {
	[self.viewComponent setDelegate:self];
}

-(void)userRolesAppeared {
	[self sendNotification:GetUserRoles body:[self.viewComponent username]];
}

-(void)userRolesDisappeared {
	[self.viewComponent clearData];
}

-(void)updateUserRolesSelected:(UserRolesVO *)userRolesVO {
	[self sendNotification:UpdateUserRoles body:userRolesVO];
}

-(NSArray *)listNotificationInterests {
	return [NSArray arrayWithObjects:GetUserRolesSuccess, nil];
}

-(void)handleNotification:(id<INotification>)notification {
	if ([[notification name] isEqualToString:GetUserRolesSuccess]) {
		[self.viewComponent reloadRole:[notification body]];
	}
}

@end
