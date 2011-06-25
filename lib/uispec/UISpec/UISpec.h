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

+(void)initialize;
+(void)runSpecsAfterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName afterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName example:(NSString *)exampleName afterDelay:(int)seconds;
+(void)runSpecs;
+(void)runSpec:(NSTimer *)timer;
+(void)runSpecExample:(NSTimer *)timer;
+(void)runSpecClasses:(NSArray *)specClasses;
+(void)runExamples:(NSArray *)examples onSpec:(Class)class;
+(void)setLog:(UILog *)log;
+(NSDictionary *)specsAndExamples;

@end

@protocol UISpec
@end

