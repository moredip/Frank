//
//  UISpec.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

@class UILog;

@interface UISpec : NSObject {

}

+(void)runSpecsAfterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName afterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName example:(NSString *)exampleName afterDelay:(int)seconds;
+(void)setLog:(UILog *)log;
+(NSDictionary *)specsAndExamples;

@end

@protocol UISpec
@end

