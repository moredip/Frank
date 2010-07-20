//
//  Observer.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "IObserver.h"

/**
 * A base <code>IObserver</code> implementation.
 * 
 * <P> 
 * An <code>Observer</code> is an object that encapsulates information
 * about an interested object with a method that should 
 * be called when a particular <code>INotification</code> is broadcast. </P>
 * 
 * <P>
 * In PureMVC, the <code>Observer</code> class assumes these responsibilities:
 * <UL>
 * <LI>Encapsulate the notification (callback) method of the interested object.</LI>
 * <LI>Encapsulate the notification context (this) of the interested object.</LI>
 * <LI>Provide methods for setting the notification method and context.</LI>
 * <LI>Provide a method for notifying the interested object.</LI>
 * </UL>
 * 
 * @see View, Notification
 */
@interface Observer : NSObject <IObserver> {
	SEL notifyMethod;
	id notifyContext;
}

@property SEL notifyMethod;
@property(nonatomic, retain) id notifyContext;

+(id)withNotifyMethod:(SEL)notifyMethod notifyContext:(id)notifyContext;
-(id)initWithNotifyMethod:(SEL)notifyMethod notifyContext:(id)notifyContext;

@end
