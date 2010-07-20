//
//  UserProxy.h
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proxy.h"

@interface UserProxy : Proxy {
}

-(void)create:(id)item;
-(void)update:(id)item;
-(void)delete:(id)item;

@end
