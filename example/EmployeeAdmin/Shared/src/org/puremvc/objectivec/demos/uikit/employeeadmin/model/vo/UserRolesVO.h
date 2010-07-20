//
//  UserRolesVO.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//


@interface UserRolesVO : NSObject {
	NSString *username;
	NSMutableArray *roles;
}

@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSMutableArray *roles;

+(id)withUsername:(NSString *)username roles:(NSArray *)roles;
-(BOOL)hasRole:(NSString *)role;

@end
