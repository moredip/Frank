#import <ObjC/runtime.h>
#import "FEXTappableConfirmationButton.h"
#import "UITableViewCell+TappableConfirmationButton.h"

void FEX_confirmDeletion(id self, SEL _cmd) {
    UITableViewCell *cell = (UITableViewCell *)[(UIView *) self superview];

    // If the cell is showing a delete button, then the
    // user entered edit mode by tapping the table's Edit
    // button.  Otherwise, the user entered edit mode by
    // swiping the cell.  If the user entered edit mode by
    // swiping, we need to end edit mode after confirming
    // deletion.  If we entered edit mode by tapping the
    // Edit button, we will leave it to the user to end
    // edit mode.
    BOOL shouldEndEditing = ![cell FEX_isShowingDeleteButton];

    UITableView *tableView = (UITableView *)[cell superview];
    id <UITableViewDataSource> dataSource = [tableView dataSource];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    [dataSource tableView:tableView
       commitEditingStyle:UITableViewCellEditingStyleDelete
        forRowAtIndexPath:indexPath];

    if (shouldEndEditing) {
//        [tableView setEditing:NO animated:YES];
        [tableView.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
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
