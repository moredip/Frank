//
//  UserRoles.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRolesVO.h"

@protocol UserRolesDelegate

-(void)userRolesAppeared;
-(void)userRolesDisappeared;
-(void)updateUserRolesSelected:(UserRolesVO *)userRolesVO;

@end


@interface UserRoles : UITableViewController {
	NSString *username;
	UserRolesVO *userRolesVO;
	id<UserRolesDelegate> delegate;
}

@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) UserRolesVO *userRolesVO;
@property(nonatomic, retain) id<UserRolesDelegate> delegate;

-(void)reloadRole:(UserRolesVO *)userRolesVO;
-(void)clearData;

@end
