//
//  Controller.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "IController.h"
#import "IView.h"

/**
 * A Singleton <code>IController</code> implementation.
 * 
 * <P>
 * In PureMVC, the <code>Controller</code> class follows the
 * 'Command and Controller' strategy, and assumes these 
 * responsibilities:
 * <UL>
 * <LI> Remembering which <code>ICommand</code>s 
 * are intended to handle which <code>INotifications</code>.</LI>
 * <LI> Registering itself as an <code>IObserver</code> with
 * the <code>View</code> for each <code>INotification</code> 
 * that it has an <code>ICommand</code> mapping for.</LI>
 * <LI> Creating a new instance of the proper <code>ICommand</code>
 * to handle a given <code>INotification</code> when notified by the <code>View</code>.</LI>
 * <LI> Calling the <code>ICommand</code>'s <code>execute</code>
 * method, passing in the <code>INotification</code>.</LI> 
 * </UL>
 * 
 * <P>
 * Your application must register <code>ICommands</code> with the 
 * Controller.
 * <P>
 * The simplest way is to subclass </code>Facade</code>, 
 * and use its <code>initializeController</code> method to add your 
 * registrations.
 *
 * @see View, Observer, Notification, SimpleCommand, MacroCommand
 */
@interface Controller : NSObject <IController> {
	NSMutableDictionary *commandMap;
	id<IView> view;
}

@property(nonatomic, retain) NSMutableDictionary *commandMap;
@property(nonatomic, retain) id<IView> view;

-(id)init;
-(void)initializeController;
+(id<IController>)getInstance;

@end
