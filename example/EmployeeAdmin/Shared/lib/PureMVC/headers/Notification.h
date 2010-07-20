//
//  Notification.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "INotification.h"

/**
 * A base <code>INotification</code> implementation.
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
 * @see Observer
 * 
 */
@interface Notification : NSObject <INotification> {
	NSString *name, *type;
	id body;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) id body;

+(id)withName:(NSString *)name body:(id)body type:(NSString *)type;
+(id)withName:(NSString *)nam;
+(id)withName:(NSString *)name body:(id)body;
+(id)withName:(NSString *)name type:(NSString *)type;
-(id)initWithName:(NSString *)name body:(id)body type:(NSString *)type;
-(NSString *)description;

@end
