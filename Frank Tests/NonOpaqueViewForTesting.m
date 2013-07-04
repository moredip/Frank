//
//  NonOpaqueViewForTesting.m
//  Frank
//
//  Created by Robert Gilliam on 7/4/13.
//
//

#import "NonOpaqueViewForTesting.h"

@implementation NonOpaqueViewForTesting

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)isOpaque
{
    return NO;
}

@end
