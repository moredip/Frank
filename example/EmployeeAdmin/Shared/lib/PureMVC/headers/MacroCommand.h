//
//  MacroCommand.h
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
 * A base <code>ICommand</code> implementation that executes other <code>ICommand</code>s.
 *  
 * <P>
 * A <code>MacroCommand</code> maintains an list of
 * <code>ICommand</code> Class references called <i>SubCommands</i>.</P>
 * 
 * <P>
 * When <code>execute</code> is called, the <code>MacroCommand</code> 
 * instantiates and calls <code>execute</code> on each of its <i>SubCommands</i> turn.
 * Each <i>SubCommand</i> will be passed a reference to the original
 * <code>INotification</code> that was passed to the <code>MacroCommand</code>'s 
 * <code>execute</code> method.</P>
 * 
 * <P>
 * Unlike <code>SimpleCommand</code>, your subclass
 * should not override <code>execute</code>, but instead, should 
 * override the <code>initializeMacroCommand</code> method, 
 * calling <code>addSubCommand</code> once for each <i>SubCommand</i>
 * to be executed.</P>
 * 
 * <P>
 * 
 * @see Controller, Notification, SimpleCommand
 */
@interface MacroCommand : Notifier <ICommand> {
	NSMutableArray *subCommands;
}

@property(nonatomic, retain) NSMutableArray *subCommands;

-(id)init;
-(void)initializeMacroCommand;
-(void)addSubCommand:(Class)commandClassRef;
+(id)command;

@end
