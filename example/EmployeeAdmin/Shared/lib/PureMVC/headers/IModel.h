#import "IProxy.h"
/**
 * The interface definition for a PureMVC Model.
 * 
 * <P>
 * In PureMVC, <code>IModel</code> implementors provide
 * access to <code>IProxy</code> objects by named lookup. </P>
 * 
 * <P>
 * An <code>IModel</code> assumes these responsibilities:</P>
 * 
 * <UL>
 * <LI>Maintain a cache of <code>IProxy</code> instances</LI>
 * <LI>Provide methods for registering, retrieving, and removing <code>IProxy</code> instances</LI>
 * </UL>
 */
@protocol IModel

/**
 * Check if a Proxy is registered
 * 
 * @param proxyName
 * @return whether a Proxy is currently registered with the given <code>proxyName</code>.
 */
-(BOOL)hasProxy:(NSString *)proxyName;

/**
 * Register an <code>IProxy</code> instance with the <code>Model</code>.
 * 
 * @param proxy an object reference to be held by the <code>Model</code>.
 */
-(void)registerProxy:(id<IProxy>)proxy;

/**
 * Remove an <code>IProxy</code> instance from the Model.
 * 
 * @param proxyName name of the <code>IProxy</code> instance to be removed.
 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
 */
-(id<IProxy>)removeProxy:(NSString *)proxyName;

/**
 * Retrieve an <code>IProxy</code> instance from the Model.
 * 
 * @param proxyName
 * @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
 */
-(id<IProxy>)retrieveProxy:(NSString *)proxyName;

@end
