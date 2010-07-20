//
//  Proxy.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "IProxy.h"
#import "Notifier.h"

/**
 * A base <code>IProxy</code> implementation. 
 * 
 * <P>
 * In PureMVC, <code>Proxy</code> classes are used to manage parts of the 
 * application's data model. </P>
 * 
 * <P>
 * A <code>Proxy</code> might simply manage a reference to a local data object, 
 * in which case interacting with it might involve setting and 
 * getting of its data in synchronous fashion.</P>
 * 
 * <P>
 * <code>Proxy</code> classes are also used to encapsulate the application's 
 * interaction with remote services to save or retrieve data, in which case, 
 * we adopt an asyncronous idiom; setting data (or calling a method) on the 
 * <code>Proxy</code> and listening for a <code>Notification</code> to be sent 
 * when the <code>Proxy</code> has retrieved the data from the service. </P>
 * 
 * @see Model
 */
@interface Proxy : Notifier <IProxy> {
	id data;
	NSString *proxyName;
}

@property(nonatomic, retain) id data;
@property(nonatomic, retain) NSString *proxyName;

+(id)proxy;
+(id)withProxyName:(NSString *)proxyName;
+(id)withProxyName:(NSString *)proxyName data:(id)data;
+(id)withData:(id)data;
-(id)initWithProxyName:(NSString *)proxyName data:(id)data;
-(void)initializeProxy;

+(NSString *)NAME;

@end
