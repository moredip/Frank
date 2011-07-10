//
//  UIEvent+Synthesis.h
//  UIExperiment
//
//  Created by Larivain, Olivier on 6/21/11.
//  Copyright 2011 Edmunds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIEvent (UIEvent_Synthesize)

+ (id) applicationEventWithTouch: (UITouch *) touch;
- (id)initWithTouch:(UITouch *)touch;
- (void) updateTimestamp;
@end

@interface UIEvent (Compiler_warnings)
// These are just definitions of private methods, will help prevent
// compiler from yelling at us for every private method call
- (void) _setTimestamp: (NSTimeInterval) interval;
- (void) _clearTouches;
- (void) _addTouch: (UITouch*) touch forDelayedDelivery: (BOOL) delayed;
@end

@interface UIApplication(Compiler_warnings)
- (UIEvent*) _touchesEvent;
@end
