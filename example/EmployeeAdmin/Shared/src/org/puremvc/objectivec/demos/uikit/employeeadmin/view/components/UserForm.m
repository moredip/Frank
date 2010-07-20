//
//  UserForm.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "UserForm.h"


@implementation UserForm

@synthesize userVO, firstNameTextField, lastNameTextField, emailTextField, usernameTextField, passwordTextField, confirmPasswordTextField, mode, delegate;

-(id)init {
	return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)loadView {
	[super loadView];
	self.navigationItem.title = @"User Profile";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser)];
	self.tableView.scrollEnabled = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return (mode == EDIT) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0) ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	if (mode == EDIT && indexPath.section == 1) {
		cell.text = @"User Roles";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (indexPath.row) {
			case 0: { //First and Last Name
				self.firstNameTextField = [self textFieldWithPlaceHolder:@"First Name" frame:CGRectMake(10,12,135,25)];
				firstNameTextField.text = userVO.firstName;
				[cell.contentView addSubview:firstNameTextField];
				
				self.lastNameTextField = [self textFieldWithPlaceHolder:@"Last Name" frame:CGRectMake(150,12,135,25)];
				lastNameTextField.text = userVO.lastName;
				[cell.contentView addSubview:lastNameTextField];
				break;
			}
			case 1: { //username and email
				self.emailTextField = [self textFieldWithPlaceHolder:@"Email" frame:CGRectMake(10,12,155,25)];
				emailTextField.text = userVO.email;
				[cell.contentView addSubview:emailTextField];
				
				self.usernameTextField = [self textFieldWithPlaceHolder:@"Username*" frame:CGRectMake(170,12,115,25)];
				usernameTextField.text = userVO.username;
				if (mode == EDIT) {
					usernameTextField.enabled = NO;
				}
				[cell.contentView addSubview:usernameTextField];
				break;
			}
			case 2: { //password and confirm
				self.passwordTextField = [self textFieldWithPlaceHolder:@"Password*" frame:CGRectMake(10,12,135,25)];
				passwordTextField.secureTextEntry = YES;
				passwordTextField.text = userVO.password;
				[cell.contentView addSubview:passwordTextField];
				
				self.confirmPasswordTextField = [self textFieldWithPlaceHolder:@"Confirm*" frame:CGRectMake(150,12,135,25)];
				confirmPasswordTextField.secureTextEntry = YES;
				confirmPasswordTextField.text = userVO.password;
				[cell.contentView addSubview:confirmPasswordTextField];
				break;
			}
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		[delegate userRolesSelected:userVO];
	}
}

-(void)saveUser {
	userVO.firstName = firstNameTextField.text;
	userVO.lastName = lastNameTextField.text;
	userVO.email = emailTextField.text;
	userVO.username = usernameTextField.text;
	userVO.password = passwordTextField.text;
	userVO.confirmPassword = confirmPasswordTextField.text;
	if (mode == NEW) {
		[delegate createUserSelected:userVO];
	} else if (mode == EDIT) {
		[delegate updateUserSelected:userVO];
	}
}

-(UITextField *)textFieldWithPlaceHolder:(NSString *)placeHolder frame:(CGRect)frame {
	UITextField *textField = [[[UITextField alloc] initWithFrame:frame] autorelease];
	textField.placeholder = placeHolder;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	return textField;
}

- (void)dealloc {
	self.userVO = nil;
	self.firstNameTextField = nil;
	self.lastNameTextField = nil;
	self.emailTextField = nil;
	self.usernameTextField = nil;
	self.passwordTextField = nil;
	self.confirmPasswordTextField = nil;
	self.delegate = nil;
    [super dealloc];
}

@end
