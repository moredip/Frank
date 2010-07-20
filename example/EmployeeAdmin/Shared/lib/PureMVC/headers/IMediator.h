#import "INotification.h"
/**
 * The interface definition for a PureMVC Mediator.
 *
 * <P>
 * In PureMVC, <code>IMediator</code> implementors assume these responsibilities:</P>
 * <UL>
 * <LI>Implement a common method which returns a list of all <code>INotification</code>s 
 * the <code>IMediator</code> has interest in.</LI>
 * <LI>Implement a notification callback method.</LI>
 * <LI>Implement methods that are called when the IMediator is registered or removed from the View.</LI>
 * </UL>
 * <P>
 * Additionally, <code>IMediator</code>s typically:
 * <UL>
 * <LI>Act as an intermediary between one or more view components such as text boxes or 
 * list controls, maintaining references and coordinating their behavior.</LI>
 * <LI>Respond to and generate <code>INotifications</code>, interacting with of 
 * the rest of the PureMVC app.
 * </UL></P>
 * <P>
 * When an <code>IMediator</code> is registered with the <code>IView</code>, 
 * the <code>IView</code> will call the <code>IMediator</code>'s 
 * <code>listNotificationInterests</code> method. The <code>IMediator</code> will 
 * return an <code>Array</code> of <code>INotification</code> names which 
 * it wishes to be notified about.</P>
 * 
 * <P>
 * The <code>IView</code> will then create an <code>Observer</code> object 
 * encapsulating that <code>IMediator</code>'s (<code>handleNotification</code>) method
 * and register it as an Observer for each <code>INotification</code> name returned by 
 * <code>listNotificationInterests</code>.</P>
 * 
 * @see INotification
 */
@protocol IMediator

/**
 * Get the <code>IMediator</code> instance name
 * 
 * @return the <code>IMediator</code> instance name
 */
-(NSString *)mediatorName;

/**
 * Get the <code>IMediator</code>'s view component.
 * 
 * @return id the view component
 */
-(id)viewComponent;

/**
 * Handle an <code>INotification</code>.
 * 
 * @param notification the <code>INotification</code> to be handled
 */
-(void)handleNotification:(id<INotification>)notification;

/**
 * List <code>INotification</code> interests.
 * 
 * @return an <code>Array</code> of the <code>INotification</code> names this <code>IMediator</code> has an interest in.
 */
-(NSArray *)listNotificationInterests;

/**
 * Called by the View when the Mediator is registered
 */ 
-(void)onRegister;

/**
 * Called by the View when the Mediator is removed
 */ 
-(void)onRemove;

/**
 * Set the <code>IMediator</code>'s view component.
 * 
 * @param viewComponent the view component
 */
-(void)setViewComponent:(id)viewComponent;

@end

