#import "INotification.h"
#import "IMediator.h"
#import "IProxy.h"
/**
 * The interface definition for a PureMVC Facade.
 *
 * <P>
 * The Facade Pattern suggests providing a single
 * class to act as a central point of communication 
 * for a subsystem. </P>
 * 
 * <P>
 * In PureMVC, the Facade acts as an interface between
 * the core MVC actors (Model, View, Controller) and
 * the rest of your application.</P>
 * 
 * @see IModel, IView, IController, ICommand, INotification
 */
@protocol IFacade

/**
 * Check if a Command is registered for a given Notification 
 * 
 * @param notificationName
 * @return whether a Command is currently registered for the given <code>notificationName</code>.
 */
-(BOOL)hasCommand:(NSString *)notificationName;

/**
 * Check if a Mediator is registered or not
 * 
 * @param mediatorName
 * @return whether a Mediator is registered with the given <code>mediatorName</code>.
 */
-(BOOL)hasMediator:(NSString *)mediatorName;

/**
 * Check if a Proxy is registered
 * 
 * @param proxyName
 * @return whether a Proxy is currently registered with the given <code>proxyName</code>.
 */
-(BOOL)hasProxy:(NSString *)proxyName;

/**
 * Notify the <code>IObservers</code> for a particular <code>INotification</code>.
 * 
 * <P>
 * All previously attached <code>IObservers</code> for this <code>INotification</code>'s
 * list are notified and are passed a reference to the <code>INotification</code> in 
 * the order in which they were registered.</P>
 * <P>
 * NOTE: Use this method only if you are sending custom Notifications. Otherwise
 * use the sendNotification method which does not require you to create the
 * Notification instance.</P> 
 * 
 * @param notification the <code>INotification</code> to notify <code>IObservers</code> of.
 */
-(void)notifyObservers:(id<INotification>)notification;

/**
 * Register an <code>ICommand</code> with the <code>Controller</code>.
 * 
 * @param notificationName the name of the <code>INotification</code> to associate the <code>ICommand</code> with.
 * @param commandClassRef a reference to the <code>Class</code> of the <code>ICommand</code>.
 */
-(void)registerCommand:(NSString *)notificationName commandClassRef:(Class)commandClassRef;

/**
 * Register an <code>IMediator</code> instance with the <code>View</code>.
 * 
 * @param mediator a reference to the <code>IMediator</code> instance
 */
-(void)registerMediator:(id<IMediator>)mediator;

/**
 * Register an <code>IProxy</code> instance with the <code>Model</code>.
 * 
 * @param proxy the <code>IProxy</code> to be registered with the <code>Model</code>.
 */
-(void)registerProxy:(id<IProxy>)proxy;

/**
 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
 * 
 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
 */
-(void)removeCommand:(NSString *)notificationName;

/**
 * Remove a <code>IMediator</code> instance from the <code>View</code>.
 * 
 * @param mediatorName name of the <code>IMediator</code> instance to be removed.
 * @return the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
 */
-(id<IMediator>)removeMediator:(NSString *)mediatorName;

/**
 * Remove an <code>IProxy</code> instance from the <code>Model</code> by name.
 *
 * @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
 */
-(id<IProxy>)removeProxy:(NSString *)proxyName;

/**
 * Retrieve an <code>IMediator</code> instance from the <code>View</code>.
 * 
 * @param mediatorName the name of the <code>IMediator</code> instance to retrievve
 * @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
 */
-(id<IMediator>)retrieveMediator:(NSString *)mediatorName;

/**
 * Retrieve a <code>IProxy</code> from the <code>Model</code> by name.
 * 
 * @param proxyName the name of the <code>IProxy</code> instance to be retrieved.
 * @return the <code>IProxy</code> previously regisetered by <code>proxyName</code> with the <code>Model</code>.
 */
-(id<IProxy>)retrieveProxy:(NSString *)proxyName;

/**
 * Create and send an <code>INotification</code>.
 * 
 * @param notificationName the name of the notiification to send
 * @param body the body of the notification
 * @param type the type of the notification
 */ 
-(void)sendNotification:(NSString *)notificationName body:(id)body type:(NSString *)type;
-(void)sendNotification:(NSString *)notificationName;
-(void)sendNotification:(NSString *)notificationName body:(id)body;
-(void)sendNotification:(NSString *)notificationName type:(NSString *)type;

@end

