//
//  RootViewController.h
//  CountItOut
//
//  Created by Adam Schepis on 10/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void) incrementValue:(id) sender;

@end
