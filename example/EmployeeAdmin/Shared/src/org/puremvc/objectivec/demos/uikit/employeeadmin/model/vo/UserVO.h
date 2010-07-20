//
//  UserVO.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserVO : NSObject {
	NSString *username, *firstName, *lastName, *email, *password, *confirmPassword, *department;
}

@property(nonatomic, retain) NSString *username, *firstName, *lastName, *email, *password, *confirmPassword, *department;

+(id)withUserName:(NSString *)username firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password confirmPassword:(NSString *)confirmPassword department:(NSString *)department;
-(NSString *)givenName;
-(BOOL)isValid;

@end
