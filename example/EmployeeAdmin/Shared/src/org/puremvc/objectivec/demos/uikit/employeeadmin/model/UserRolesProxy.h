//
//  UserRolesProxy.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "Proxy.h"
#import "UserRolesVO.h"
#import "UserVO.h"

@interface UserRolesProxy : Proxy {
}

-(void)update:(id)item;
-(UserRolesVO *)findByUsername:(NSString *)username;

@end
