//
//  RootViewController.m
//  Controls
//
//  Created by Pete Hodgson on 9/30/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "RootViewController.h"
#import "UISwitchViewController.h"
#import "CarouselViewController.h"
#import "EditableTableViewController.h"
#import "DataEntryViewController.h"
#import "UIProgressViewController.h"
#import "ViewPropertiesViewController.h"
#import "LocationViewController.h"
#import "SampleTableViewController.h"
#import "LongTouchViewController.h"
#import "DoubleTapViewController.h"
#import "AlertViewController.h"

typedef enum {
    RowsUISwitch,
    RowsCarousel,
    RowsEditableTable,
    RowsDataEntry,
    RowsUIProgressView,
    RowsViewProperties,
    RowsLocation,
	RowsLongPress,
	RowsDoubleTap,
    RowsEmptyTable,
    RowsUIAlertView,
    RowsCount,
} Rows;

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Root";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RowsCount;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch ([indexPath row]) {
        case RowsUISwitch:
            cell.textLabel.text = @"UISwitch";
            break;
        case RowsCarousel:
            cell.textLabel.text = @"Carousel";
            break;
        case RowsEditableTable:
            cell.textLabel.text = @"Editable Table";
            break;
        case RowsDataEntry:
            cell.textLabel.text = @"Data Entry";
            break;
        case RowsUIProgressView:
            cell.textLabel.text = @"UIProgressView";
            break;
        case RowsViewProperties:
            cell.textLabel.text = @"View Properties";
            break;
        case RowsLocation:
            cell.textLabel.text = @"Location";
            break;
		case RowsLongPress:
			cell.textLabel.text = @"Long Press";
			break;
		case RowsDoubleTap:
			cell.textLabel.text = @"Double Tap";
			break;
        case RowsEmptyTable:
            cell.textLabel.text = @"Empty Table";
            break;
        case RowsUIAlertView:
            cell.textLabel.text = @"UIAlertView";
            break;
    }

    // Configure the cell.
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailVC;

    switch ([indexPath row]) {
        case RowsUISwitch:
            detailVC = [[UISwitchViewController alloc] initWithNibName:@"UISwitchViewController" bundle:nil];
            break;
        case RowsCarousel:
            detailVC = [[CarouselViewController alloc] init];
            break;
        case RowsEditableTable:
            detailVC = [[EditableTableViewController alloc] init];
            break;
        case RowsDataEntry:
            detailVC = [[DataEntryViewController alloc] init];
            break;
        case RowsUIProgressView:
            detailVC = [[UIProgressViewController alloc] initWithNibName:@"UIProgressViewController" bundle:nil];
            break;
        case RowsViewProperties:
            detailVC = [[ViewPropertiesViewController alloc] initWithNibName:@"ViewPropertiesViewController" bundle:nil];
            break;
        case RowsLocation:
            detailVC = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
            break;
		case RowsLongPress:
			detailVC = [[LongTouchViewController alloc] initWithNibName:@"LongTouchViewController" bundle:nil];
			break;
		case RowsDoubleTap:
			detailVC = [[DoubleTapViewController alloc] initWithNibName:@"DoubleTapViewController" bundle:nil];
			break;
        case RowsEmptyTable:
            detailVC = [[SampleTableViewController alloc] init];
            break;
        case RowsUIAlertView:
            detailVC = [[AlertViewController alloc] initWithNibName:@"AlertViewController" bundle:nil];
            break;

    }

    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
