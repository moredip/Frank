//
//  ViewJSONSerializer.h
//  Frank
//
//  Created by Olivier Larivain on 2/24/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewJSONSerializer : NSObject
+ (NSObject *) jsonify: (id<NSObject>) obj;

+ (id) extractInstanceFromValue: (NSValue *) value;
+ (id) extractInstanceFromColor: (id) color;
+ (id) extractInstanceFromFont: (id) font;
@end
