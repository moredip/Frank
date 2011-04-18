//
//  CountUpViewController.m
//  CountItOut
//
//  Created by Adam Schepis on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CountUpViewController.h"
#import "CounterTypes.h"
#import "NameValueCell.h"

@implementation CountUpViewController

#define TAG_GROUP_FIELD (0)
#define TAG_NAME_FIELD (1)
#define TAG_MAX_VALUE_FIELD (2)
#define TAG_INCREMENT_FIELD (3)

#define NUMBERS	@"0123456789"

@synthesize managedObjectContext, countUpObject;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad 
{
    [super viewDidLoad];

	isNewObject = (nil == countUpObject);
	
	if (isNewObject)
	{
		self.navigationItem.title = @"Count Up";
		
		countUpObject = [NSEntityDescription insertNewObjectForEntityForName:@"Counter" inManagedObjectContext:managedObjectContext];
		[countUpObject setValue:[NSNumber numberWithInt:COUNTUP] forKey:@"Type"];
		[countUpObject setValue:[NSNumber numberWithInt:0] forKey:@"Value"];
		 
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
									   initWithTitle:NSLocalizedString(@"Save", @"Save - for button to save changes")
									   style:UIBarButtonSystemItemEdit
									   target:self
									   action:@selector(save:)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
	}
	else 
	{
		self.navigationItem.title = (NSString *) [countUpObject valueForKey:@"Name"];
	}

}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated 
{
	// rollback changes in case the user didnt hit save.
	[managedObjectContext rollback];
	[super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void) save:(id) sender
{
	// tell any text field that might be the first responder to resign that
	// responsibility.
	if (nil != textFieldGroup)
		[textFieldGroup resignFirstResponder];
	if (nil != textFieldName)
		[textFieldName resignFirstResponder];
	if (nil != textFieldMaxValue)
		[textFieldMaxValue resignFirstResponder];
	if (nil != textFieldIncrement)
		[textFieldIncrement resignFirstResponder];
	
	// see if group exists or if it has to be creates
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat: @"Name == %@", textFieldGroup.text];
	[fetchRequest setPredicate:predicate];
	
	NSError *error;
	NSArray *fetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (nil == fetchResults)
	{
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	if (fetchResults.count == 0)
	{		
		NSManagedObject *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:managedObjectContext];
		[group setValue:textFieldGroup.text forKey:@"Name"];
		[countUpObject setValue:group forKey:@"Group"];
	}
	else 
	{
		NSManagedObject *group = [fetchResults objectAtIndex:0]; 
		[countUpObject setValue:group forKey:@"Group"];
	}
	
	[fetchResults release];
	[fetchRequest release];
		
	// persist changes
	if (![managedObjectContext save:&error]) 
	{
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error localizedDescription]);
		
		exit(-1);  // Fail
	} 
	
	// pop to root
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"Group";
			break;
			
		case 1:
			return @"Count Up";
			break;
	}
	return nil;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			return 3;
			break;
	}
	
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NameValueCell";
    
	NameValueCell *nvCell = (NameValueCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == nvCell)
	{
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:nil options:nil];
		
		for (id currentObject in topLevelObjects)
		{
			if ([currentObject isKindOfClass:[UITableViewCell class]])
			{
				nvCell = (NameValueCell *) currentObject;
				break;
			}
		}
	}
	
	nvCell.value.delegate = self;

	switch (indexPath.section)
	{
		case 0:
		{
			nvCell.value.tag = TAG_GROUP_FIELD;
			nvCell.name.text = @"Group:";
			nvCell.value.placeholder = @"Group Name";
			nvCell.value.autocapitalizationType = UITextAutocapitalizationTypeWords;
			textFieldGroup = nvCell.value;
			break;
		}
			
		case 1:
		{
			switch (indexPath.row)
			{
				case 0:
					nvCell.value.tag = TAG_NAME_FIELD;
					nvCell.name.text = @"Name:";
					nvCell.value.placeholder = @"Counter Name";
					nvCell.value.autocapitalizationType = UITextAutocapitalizationTypeWords;

					textFieldName = nvCell.value;
					break;
				case 1:
					nvCell.value.tag = TAG_MAX_VALUE_FIELD;
					nvCell.name.text = @"Max Value:";
					nvCell.value.placeholder = @"Max Value";
					nvCell.value.keyboardType = UIKeyboardTypeNumbersAndPunctuation;					

					textFieldMaxValue = nvCell.value;
					break;
				case 2:
					nvCell.value.tag = TAG_INCREMENT_FIELD;
					nvCell.name.text = @"Increment:";
					nvCell.value.placeholder = @"Increment";
					nvCell.value.keyboardType = UIKeyboardTypeNumbersAndPunctuation;					

					textFieldIncrement = nvCell.value;
					break;
			}
		}
	}
	
    return nvCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark TextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (textField.tag == TAG_MAX_VALUE_FIELD || textField.tag == TAG_INCREMENT_FIELD)
	{
		NSCharacterSet *cs;
		NSString *filtered;
		
		cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
		filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
		return [string isEqualToString:filtered];
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	switch (textField.tag) 
	{
		case TAG_NAME_FIELD:
			[countUpObject setValue:[NSString stringWithString:textField.text] forKey:@"Name"];
			self.navigationItem.title = (NSString *) [countUpObject valueForKey:@"Name"];
			break;
		case TAG_INCREMENT_FIELD:
			[countUpObject setValue:[NSNumber numberWithInt:textField.text.intValue] forKey:@"Increment"];
			break;
		case TAG_MAX_VALUE_FIELD:
			if (textField.text.length == 0)
				[countUpObject setValue:nil forKey:@"MaxValue"];
			else
				[countUpObject setValue:[NSNumber numberWithInt:textField.text.intValue] forKey:@"MaxValue"];
			break;
	}
}

#pragma mark Memory

- (void)dealloc {
	[managedObjectContext release];
    [super dealloc];
}

@end

