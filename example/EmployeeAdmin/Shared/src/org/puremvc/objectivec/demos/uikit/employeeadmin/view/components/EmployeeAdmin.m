//
//  EmployeeAdmin.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "EmployeeAdmin.h"


@implementation EmployeeAdmin

@synthesize userList, userForm, userRoles, navigation;

-(id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.navigation = [[[UINavigationController alloc] init] autorelease];
		self.userList = [[[UserList alloc] init] autorelease];
		self.userForm = [[[UserForm alloc] init] autorelease];
		self.userRoles = [[[UserRoles alloc] init] autorelease];
		[navigation pushViewController:userList animated:NO];
		[self addSubview:navigation.view];
	}
	return self;
}

-(void)showUserForm {
	[navigation pushViewController:userForm animated:YES];
}

-(void)showUserList {
	[navigation popToRootViewControllerAnimated:YES];
}

-(void)showUserRoles:(NSString *)username {
	userRoles.username = username;
	[navigation pushViewController:userRoles animated:YES];
}

-(void)showError:(NSString *)message {
	[[[[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
}

-(void)removeUserRoles {
	[navigation popViewControllerAnimated:YES];
}

- (void)dealloc {
	self.navigation = nil;
	self.userList = nil;
	self.userForm = nil;
	self.userRoles = nil;
    [super dealloc];
}

@end
