
@implementation UITableViewCell (ConfirmDeletionButton)

-(BOOL)FEX_isShowingDeleteButton {
    Class deleteButtonClass = NSClassFromString(@"UITableViewCellEditControl");
    for(UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:deleteButtonClass]) {
            return YES;
        }
    }
    return NO;
}
@end

