#import "INotification.h"
/**
 * The interface definition for a PureMVC Command.
 *
 * @see INotification
 */
@protocol ICommand

/**
 * Execute the <code>ICommand</code>'s logic to handle a given <code>INotification</code>.
 * 
 * @param notification an <code>INotification</code> to handle.
 */
-(void)execute:(id<INotification>)notification;

@end