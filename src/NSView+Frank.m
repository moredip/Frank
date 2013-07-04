//
//  NSView+Frank.m
//  Frank
//
//  Created by Toshiyuki Suzumura on 2013/07/04.
//

#import "NSView+Frank.h"

@implementation NSView (Frank)

- (NSString *) FEX_UID {
    return [NSString stringWithFormat:@"%lu",(uintptr_t)self];
}

@end
