//
//  VisibleTouch.h
//  myMusicStand
//
//  Simple class to provide a circle similar to the one provide by 
//  the ios simulator this makes debugging touches easier
//  
//  Created by Steve Solomon on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisibleTouch : UIView

// Designated Initializer all others throw exceptions =)
- (id)initWithCenter:(CGPoint)ctr;

- (void) addToKeyWindow;

@end
