//
//  UserRoles.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserRoles.h"
#import "UserRolesEnum.h"

#define ROLE_CELL_ID @"ROLE_CELL_ID"

@implementation UserRoles

@synthesize username, userRolesVO, delegate;

-(id)init {
	return [super initWithStyle:UITableViewStylePlain];
}

- (void)loadView {
	[super loadView];
	self.navigationItem.title = @"User Roles";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveRoles)];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[delegate userRolesAppeared];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[delegate userRolesDisappeared];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[UserRolesEnum list] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *roleCell = [tableView dequeueReusableCellWithIdentifier:ROLE_CELL_ID];
	if (roleCell == nil) {
		roleCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ROLE_CELL_ID] autorelease];
		roleCell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	NSString *role = [[UserRolesEnum list] objectAtIndex:indexPath.row];
	roleCell.text = role;
	if ([userRolesVO hasRole:role]) {
		roleCell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		roleCell.accessoryType = UITableViewCellAccessoryNone;
	}
	return roleCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *role = [[UserRolesEnum list] objectAtIndex:indexPath.row];
	UITableViewCell *roleCell = [tableView cellForRowAtIndexPath:indexPath];
	if (roleCell.accessoryType == UITableViewCellAccessoryCheckmark) {
		roleCell.accessoryType = UITableViewCellAccessoryNone;
		[userRolesVO.roles removeObject:role];
	} else {
		roleCell.accessoryType = UITableViewCellAccessoryCheckmark;
		[userRolesVO.roles addObject:role];
	}
}

-(void)saveRoles {
	[delegate updateUserRolesSelected:userRolesVO];
}

-(void)reloadRole:(UserRolesVO *)_userRolesVO {
	self.userRolesVO = _userRolesVO;
	[self.tableView reloadData];
}

-(void)clearData {
	self.userRolesVO = nil;
	for (int i = 0; i<[[UserRolesEnum list] count]; i++) {
		[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryNone;
	}
}

- (void)dealloc {
	self.username = nil;
	self.delegate = nil;
	self.userRolesVO = nil;
	[super dealloc];
}

@end
