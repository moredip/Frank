//
//  VisibleTouch.m
//  myMusicStand
//
//  Created by Steve Solomon on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define BORDER 3 // border size what we draw
#import "VisibleTouch.h"

@implementation VisibleTouch

- (id)initWithFrame:(CGRect)frame
{
    @throw @"Illegal instance please use initWithCenter method instead";
}

- (id)init
{
    @throw @"Illegal instance please use initWithCenter method instead";
}

- (id)initWithCenter:(CGPoint)ctr
{
    self = [super initWithFrame:CGRectMake(0, 0, 54, 54)];
    
    if (self)
    {
        [self setCenter:ctr];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void) addToKeyWindow{
	[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
     
    // Clear our dirty rect
    CGContextClearRect(context, rect);
    
    // Shadow for circle 
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 5, [[UIColor blackColor] CGColor]);
    
    // Draw circle 
    CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    // draw circle with border on all sides
    rect.origin.x += 3;
    rect.origin.y += 3;
    rect.size.width -= 6;
    rect.size.height -= 6;
    CGContextFillEllipseInRect(context, rect);
    
    CGContextRestoreGState(context);
}


@end
