
#import "UIQueryTableViewCell.h"


@implementation UIQueryTableViewCell

-(UIQuery *)delete {

	UITableView *tableView = self.parent.tableView;
	[tableView.dataSource tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[tableView indexPathForCell:[self.views objectAtIndex:0]]];
	return self.parent;
}

@end
