/**
 * The interface definition for a PureMVC Notification.
 *
 * <P>
 * PureMVC does not rely upon underlying event models such 
 * as the one provided with in AppKit or UIKit</P>
 * 
 * <P>
 * The Observer Pattern as implemented within PureMVC exists 
 * to support event-driven communication between the 
 * application and the actors of the MVC triad.</P>
 * 
 * <P>
 * Notifications are not meant to be a replacement for Events
 * in AppKit or UIKit. Generally, <code>IMediator</code> implementors
 * place event listeners on their view components, which they
 * then handle in the usual way. This may lead to the broadcast of <code>Notification</code>s to 
 * trigger <code>ICommand</code>s or to communicate with other <code>IMediators</code>. <code>IProxy</code> and <code>ICommand</code>
 * instances communicate with each other and <code>IMediator</code>s 
 * by broadcasting <code>INotification</code>s.</P>
 * 
 * @see IView, IObserver
 */
@protocol INotification

/**
 * Get the body of the <code>INotification</code> instance
 */
-(id)body;

/**
 * Get the name of the <code>INotification</code> instance. 
 * No setter, should be set by constructor only
 */
-(NSString *)name;

/**
 * Get the type of the <code>INotification</code> instance
 */
-(NSString *)type;

/**
 * Set the body of the <code>INotification</code> instance
 */
-(void)setBody:(id)body;

/**
 * Set the type of the <code>INotification</code> instance
 */
-(void)setType:(NSString *)type;

/**
 * Get the string representation of the <code>INotification</code> instance
 */
-(NSString *)description;

@end
