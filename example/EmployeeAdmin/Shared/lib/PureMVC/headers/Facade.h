//
//  Facade.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFacade.h"
#import "IController.h"
#import "IModel.h"
#import "IView.h"

/**
 * A base Singleton <code>IFacade</code> implementation.
 * 
 * <P>
 * In PureMVC, the <code>Facade</code> class assumes these 
 * responsibilities:
 * <UL>
 * <LI>Initializing the <code>Model</code>, <code>View</code>
 * and <code>Controller</code> Singletons.</LI> 
 * <LI>Providing all the methods defined by the <code>IModel, 
 * IView, & IController</code> interfaces.</LI>
 * <LI>Providing the ability to override the specific <code>Model</code>,
 * <code>View</code> and <code>Controller</code> Singletons created.</LI> 
 * <LI>Providing a single point of contact to the application for 
 * registering <code>Commands</code> and notifying <code>Observers</code></LI>
 * </UL>
 * <P>
 * 
 * @see Model, View, Controller, Notification, Mediator, Proxy, SimpleCommand, MacroCommand
 */
@interface Facade : NSObject <IFacade> {
	id<IController> controller;
	id<IModel> model;
	id<IView> view;
}

@property(nonatomic, retain) id<IController> controller;
@property(nonatomic, retain) id<IModel> model;
@property(nonatomic, retain) id<IView> view;

-(id)init;
-(void)initializeFacade;
+(id<IFacade>)getInstance;
-(void)initializeController;
-(void)initializeView;
-(void)initializeModel;

@end
