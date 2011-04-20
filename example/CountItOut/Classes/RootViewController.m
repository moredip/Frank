//
//  RootViewController.m
//  CountItOut
//
//  Created by Adam Schepis on 10/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "NewCounterSelectTypeController.h"
#import "CounterTypes.h"


@implementation RootViewController

@synthesize fetchedResultsController, managedObjectContext;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	// Set up the edit and add buttons.
	self.navigationItem.title = @"Count it Out";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
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
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject 
{
	
	NewCounterSelectTypeController *controller = [[NewCounterSelectTypeController alloc] initWithNibName:@"NewCounterSelectType" bundle:nil];
	controller.managedObjectContext = self.managedObjectContext;

	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if ([[fetchedResultsController sections] count] == 0)
		return 1;
    return [[fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([[fetchedResultsController sections] count] == 0)
	{
		return @"Hit '+' to get started";
	}

	id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if ([[fetchedResultsController sections] count] == 0)
		return 0;
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellValueIdentifier = @"CellValue";
    
	id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:indexPath.section];
	if (indexPath.row == [sectionInfo numberOfObjects])
	{
		// footer row
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.textLabel.text = @"Zero Counts";
		cell.detailTextLabel.text = @"";
		return cell;
	}

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellValueIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellValueIdentifier] autorelease];
	}
	
	// Configure the cell.
	NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [[managedObject valueForKey:@"Name"] description];
	cell.detailTextLabel.text = [[managedObject valueForKey:@"Value"] description];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:indexPath.section];
    if (indexPath.row == [sectionInfo numberOfObjects])
		return NO;
	
	return YES;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:proposedDestinationIndexPath.section];

	if(sourceIndexPath.section != proposedDestinationIndexPath.section)
    {
        return sourceIndexPath;
    }
	else if (proposedDestinationIndexPath.row >= [sectionInfo numberOfObjects])
	{
		return [NSIndexPath indexPathForRow:[sectionInfo numberOfObjects] - 1 inSection:proposedDestinationIndexPath.section];
	}
    else
    {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	if (fromIndexPath.section != toIndexPath.section)
		return;
	
	NSManagedObject *fromObject = [[self fetchedResultsController] objectAtIndexPath:fromIndexPath];
	NSManagedObject *toObject = [[self fetchedResultsController] objectAtIndexPath:toIndexPath];
	
	int toRank = ((NSNumber *)[toObject valueForKey:@"Rank"]).intValue;
	
	if (toIndexPath.row > fromIndexPath.row)
		[fromObject setValue:[NSNumber numberWithInt: toRank + 1] forKey:@"Rank"];		
	else
		[fromObject setValue:[NSNumber numberWithInt: toRank - 1] forKey:@"Rank"];		
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:indexPath.section];
	if (indexPath.row == [sectionInfo numberOfObjects])
	{
		for (id obj in sectionInfo.objects)
		{
			NSManagedObject *managedObj = (NSManagedObject *) obj;
			NSNumber *type = [managedObj valueForKey:@"Type"];

			if (COUNTUP == type.intValue)
			{
				[managedObj setValue:[NSNumber numberWithInt:0] forKey:@"Value"];
			}
			else 
			{
				NSNumber *start = [managedObj valueForKey:@"MaxValue"];
				[managedObj setValue:[NSNumber numberWithInt:start.intValue] forKey:@"Value"];
			}
		}
	}
	else 
	{
		[self incrementValue:indexPath];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

-(void) incrementValue:(id) sender
{
	NSIndexPath *indexPath = (NSIndexPath *)sender;
	NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	NSNumber *type = [selectedObject valueForKey:@"Type"];
	NSNumber *value = [selectedObject valueForKey:@"Value"];
	NSNumber *increment = [selectedObject valueForKey:@"Increment"];
	
	if (COUNTUP == type.intValue)
	{
		NSNumber *max = [selectedObject valueForKey:@"MaxValue"];
		
		int newValue = value.intValue + increment.intValue;
		if (nil != max && max.intValue > 0 && newValue > max.intValue)
		{
			newValue -= (max.intValue + increment.intValue);
		}
		
		[selectedObject setValue:[NSNumber numberWithInt:newValue] forKey:@"Value"];
	}
	else if (COUNTDOWN == type.intValue)
	{
		NSNumber *start = [selectedObject valueForKey:@"MaxValue"];
		
		int newValue = value.intValue - increment.intValue;
		if (newValue < 0)
		{
			newValue = start.intValue;
		}
		
		[selectedObject setValue:[NSNumber numberWithInt:newValue] forKey:@"Value"];
	}
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:indexPath.section];
    if (indexPath.row == [sectionInfo numberOfObjects])
		return NO;

	return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
	}   
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) 
	{
        return fetchedResultsController;
    }
    
    /*
	 Set up the fetched results controller.
	*/
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Counter" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"Group.Name" ascending:YES];
	NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"Rank" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorGroup, sortDescriptorName, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"Group.Name" cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptorGroup release];
	[sortDescriptorName release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

/*
 Instead of using controllerDidChangeContent: to respond to all changes, you can implement all the delegate methods to update the table view in response to individual changes.  This may have performance implications if a large number of changes are made simultaneously.

// Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	// Update the table view appropriately.
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	// Update the table view appropriately.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
} 
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

