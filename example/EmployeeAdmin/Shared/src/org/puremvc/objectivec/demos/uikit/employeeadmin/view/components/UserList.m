//
//  UserList.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserList.h"

#define USER_CELL_ID @"UserCellID"

@implementation UserList

@synthesize users, delegate;

-(id)init {
	return [super initWithStyle:UITableViewStylePlain];
}

- (void)loadView {
	[super loadView];
	self.users = [NSMutableArray array];
	//self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Users";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newUser)];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[delegate userListAppeared];
}

-(void)reloadUsers:(NSMutableArray *)_users {
	self.users = _users;
	[self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	UserVO *userVO = [[users objectAtIndex:indexPath.row] retain];
	[users removeObjectAtIndex:indexPath.row];
	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[delegate deleteUserSelected:userVO];
	[userVO release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:USER_CELL_ID];
	if (userCell == nil) {
		userCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:USER_CELL_ID] autorelease];
		userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	UserVO *userVO = [users objectAtIndex:indexPath.row];
	userCell.text = [userVO givenName];
	return userCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [users count];
}

-(void)newUser {
	[delegate newUserSelected];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate userSelected:[users objectAtIndex:indexPath.row]];
}

- (void)dealloc {
	self.users = nil;
	self.delegate = nil;
    [super dealloc];
}


@end
