//
//  Mediator.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMediator.h"
#import "Notifier.h"

/**
 * A base <code>IMediator</code> implementation. 
 * 
 * @see View
 */
@interface Mediator : Notifier <IMediator> {
	NSString *mediatorName;
	id viewComponent;
}

@property(nonatomic, retain) id viewComponent;
@property(nonatomic, retain) NSString *mediatorName;

+(id)mediator;
+(id)withMediatorName:(NSString *)mediatorName;
+(id)withMediatorName:(NSString *)mediatorName viewComponent:(id)viewComponent;
+(id)withViewComponent:(id)viewComponent;
-(id)initWithMediatorName:(NSString *)mediatorName viewComponent:(id)viewComponent;
-(void)initializeMediator;

+(NSString *)NAME;

@end
