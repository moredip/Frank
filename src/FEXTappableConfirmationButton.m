#import <ObjC/runtime.h>
#import "FEXTappableConfirmationButton.h"
#import "UITableViewCell+TappableConfirmationButton.h"

void FEX_confirmDeletion(id self, SEL _cmd) {
    UITableViewCell *cell = (UITableViewCell *)[(UIView *) self superview];
    UITableView *tableView = (UITableView *)[cell superview];
    id <UITableViewDataSource> dataSource = [tableView dataSource];

    // If the data source does not implement tableView:commitEditingStyle:forRowAtIndexPath:,
    // the table is unable to delete cells.  See the diagram and discussion here:
    // http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html
    if (![dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) return;

    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    [dataSource tableView:tableView
       commitEditingStyle:UITableViewCellEditingStyleDelete
        forRowAtIndexPath:indexPath];

    // If the cell is showing a delete button, then the
    // user entered edit mode by tapping the table's Edit
    // button.  Otherwise, the user entered edit mode by
    // swiping the cell.  If the user entered edit mode by
    // swiping, we need to end edit mode after confirming
    // deletion.  If we entered edit mode by tapping the
    // Edit button, we will leave it to the user to end
    // edit mode.
    BOOL shouldEndEditing = ![cell FEX_isShowingDeleteButton];
    if (shouldEndEditing) {
        [tableView setEditing:NO animated:YES];
        id <UITableViewDelegate> delegate = tableView.delegate;
        if ([delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
            [delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
        }
    }
}

@implementation FEXTappableConfirmationButton

+ (void)install {
    Class confirmationButtonClass = NSClassFromString(@"UITableViewCellDeleteConfirmationControl");
    char *const voidNoArgsType = "v@:";

    class_replaceMethod(confirmationButtonClass, NSSelectorFromString(@"tap"), (IMP) FEX_confirmDeletion, voidNoArgsType);
    class_replaceMethod(confirmationButtonClass, NSSelectorFromString(@"touch"), (IMP) FEX_confirmDeletion, voidNoArgsType);
}

@end
