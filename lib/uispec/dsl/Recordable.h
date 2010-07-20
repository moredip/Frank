//
//  UIFunction.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

@interface Recordable : NSObject {
	id target, play;
	NSInvocation *invocation;
}

@property(nonatomic, retain) id target;
@property(nonatomic, retain) NSInvocation *invocation;
@property(nonatomic, readonly) id play;

+(id)withTarget:(id)target;

@end
