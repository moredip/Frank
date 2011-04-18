//
//  NewCounterSelectTypeController.h
//  CountItOut
//
//  Created by Adam Schepis on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewCounterSelectTypeController : UITableViewController {
	NSManagedObjectContext *managedObjectContext;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
