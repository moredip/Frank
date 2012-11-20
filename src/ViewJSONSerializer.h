//
//  ViewJSONSerializer.h
//  Frank
//
//  Created by Olivier Larivain on 2/24/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#define FrankColor UIColor
#define FrankFont  UIFont
#else
#define FrankColor NSColor
#define FrankFont  NSFont
#endif

@interface ViewJSONSerializer : NSObject
+ (NSObject *) jsonify: (id<NSObject>) obj;

+ (id) extractInstanceFromValue: (NSValue *) value;
+ (id) extractInstanceFromColor: (FrankColor *) color;
+ (id) extractInstanceFromFont: (FrankFont *) font;
@end
