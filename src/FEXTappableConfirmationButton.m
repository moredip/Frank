#import <ObjC/runtime.h>
#import "FEXTappableConfirmationButton.h"

void FEX_tapConfirmDeletionButton(id self, SEL _cmd) {
    UIView *this = (UIView *)self;
    UITableViewCell *cell = (UITableViewCell *)[this superview];
    UITableView *tableView = (UITableView *)[cell superview];
    id <UITableViewDataSource> dataSource = [tableView dataSource];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    [dataSource tableView:tableView
       commitEditingStyle:UITableViewCellEditingStyleDelete
        forRowAtIndexPath:indexPath];
}

@implementation FEXTappableConfirmationButton

+ (void)install {
    Class confirmationButtonClass = NSClassFromString(@"UITableViewCellDeleteConfirmationControl");
    SEL tapSelector = NSSelectorFromString(@"tap");
    char *const voidNoArgsType = "v@:";

    class_replaceMethod(confirmationButtonClass, tapSelector, (IMP) FEX_tapConfirmDeletionButton, voidNoArgsType);
}

@end
