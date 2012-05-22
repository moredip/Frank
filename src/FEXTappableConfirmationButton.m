#import <ObjC/runtime.h>
#import "FEXTappableConfirmationButton.h"

void FEX_touchConfirmDeletionButton(id self, SEL _cmd) {
    UIView *this = (UIView *)self;
    UITableViewCell *cell = (UITableViewCell *)[this superview];
    UITableView *tableView = (UITableView *)[cell superview];
    id <UITableViewDataSource> dataSource = [tableView dataSource];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    [dataSource tableView:tableView
       commitEditingStyle:UITableViewCellEditingStyleDelete
        forRowAtIndexPath:indexPath];
    [tableView setEditing:NO animated:YES];
}

@implementation FEXTappableConfirmationButton

+ (void)install {
    Class confirmationButtonClass = NSClassFromString(@"UITableViewCellDeleteConfirmationControl");
    SEL tapSelector = NSSelectorFromString(@"touch");
    char *const voidNoArgsType = "v@:";

    class_replaceMethod(confirmationButtonClass, tapSelector, (IMP) FEX_touchConfirmDeletionButton, voidNoArgsType);
}

@end
