//
//  UserRolesVO.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserRolesVO.h"


@implementation UserRolesVO

@synthesize username, roles;

+(id)withUsername:(NSString *)username roles:(NSMutableArray *)roles {
	UserRolesVO *userRolesVO = [[[UserRolesVO alloc] init] autorelease];
	userRolesVO.username = username;
	userRolesVO.roles = roles;
	return userRolesVO;
}

-(BOOL)hasRole:(NSString *)role {
	return [roles containsObject:role];
}

-(void)dealloc {
	self.username = nil;
	self.roles = nil;
	[super dealloc];
}

@end
