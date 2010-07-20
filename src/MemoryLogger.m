//
//  MemoryLogger.m
//  Frank
//
//  Created by Derek Longmuir on 5/31/10.
//  Copyright 2010 ThoughtWorks. All rights reserved.
//

#import "FrankServer.h"
#import "MemoryLogger.h"

static MemoryLogger *instance = nil;

@implementation MemoryLogger
@synthesize logLines = _logLines;
@synthesize linesToKeep;

+(MemoryLogger *)instance {
	@synchronized(self) {
		if( instance == nil ) {
			instance = [[MemoryLogger alloc] init];
			instance.logLines = [[NSMutableArray alloc]init];
		}
	}
	return instance;
}

+(void) log: (NSString *)logstring {
	MemoryLogger *instance = [MemoryLogger instance];
	[instance.logLines addObject: logstring];
//	printf( "Size of loglines is: %i", [instance.logLines count]);
}

// TODO I'm sure this performance is terrible.
+(NSString *)getLog {
	MemoryLogger *instance = [MemoryLogger instance];
	NSMutableString *output = [[[NSMutableString alloc] init] autorelease];
	for (NSString *line in instance.logLines) {
		[output appendString:(NSString *)line];
		[output appendString: @"\n"];
	}
	
	return output;
}
@end
