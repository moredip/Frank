//
//  NSScreen+Frank.m
//  Frank
//
//  Created by Buckley on 7/24/13.
//
//

#import "NSScreen+Frank.h"

@implementation NSScreen (Frank)

+ (CGRect) FEX_flipCoordinates: (CGRect) aRect
{
    CGFloat screenHeight = 0;
    
    for (NSScreen* screen in [NSScreen screens])
    {
        NSRect screenFrame = [screen convertRectFromBacking: [screen frame]];
        screenHeight = MAX(screenHeight, screenFrame.origin.y + screenFrame.size.height);
    }
    
    CGFloat flippedY = screenHeight - (aRect.origin.y + aRect.size.height);
    
    if (flippedY >= 0)
    {
        aRect.origin.y = flippedY;
    }
    
    return aRect;
}

@end
