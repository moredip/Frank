//
//  SimpleCommand.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <Foundation/Foundation.h>
#import "INotification.h"
#import "Notifier.h"
#import "ICommand.h"

/**
 * A base <code>ICommand</code> implementation.
 * 
 * <P>
 * Your subclass should override the <code>execute</code> 
 * method where your business logic will handle the <code>INotification</code>. </P>
 * 
 * @see Controller, Notification, MacroCommand
 */
@interface SimpleCommand : Notifier <ICommand> {
}

+(id)command;

@end
