//
//  Model.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "IModel.h"

/**
 * A Singleton <code>IModel</code> implementation.
 * 
 * <P>
 * In PureMVC, the <code>Model</code> class provides
 * access to model objects (Proxies) by named lookup. 
 * 
 * <P>
 * The <code>Model</code> assumes these responsibilities:</P>
 * 
 * <UL>
 * <LI>Maintain a cache of <code>IProxy</code> instances.</LI>
 * <LI>Provide methods for registering, retrieving, and removing 
 * <code>IProxy</code> instances.</LI>
 * </UL>
 * 
 * <P>
 * Your application must register <code>IProxy</code> instances 
 * with the <code>Model</code>. Typically, you use an 
 * <code>ICommand</code> to create and register <code>IProxy</code> 
 * instances once the <code>Facade</code> has initialized the Core 
 * actors.</p>
 *
 * @see Proxy, IProxy
 */
@interface Model : NSObject <IModel> {
	NSMutableDictionary *proxyMap;
}

@property(nonatomic, retain) NSMutableDictionary *proxyMap;

-(id)init;
-(void)initializeModel;
+(id<IModel>)getInstance;

@end
