//
//  MemoryLogger.h
//  Frank
//
//  Created by Derek Longmuir on 5/31/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import <Foundation/Foundation.h>
#import "MemoryLogger.h"

@interface MemoryLogger : NSObject {
	NSMutableArray *_logLines;
	NSUInteger linesToKeep;
}

@property (nonatomic, retain) NSMutableArray *logLines;
@property NSUInteger linesToKeep;

+(void) log: (NSString *)logstring;
+(NSString *)getLog;

@end
