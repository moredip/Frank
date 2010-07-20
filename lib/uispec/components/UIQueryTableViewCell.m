
#import "UIQueryTableViewCell.h"


@implementation UIQueryTableViewCell

-(void)delete {
	UITableView *tableView = self.parent.tableView;
	[tableView.dataSource tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[tableView indexPathForCell:[self.views objectAtIndex:0]]];
}

@end
