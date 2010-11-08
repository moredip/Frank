//
//  FrankServer.m
//  Frank
//
//  Created by phodgson on 5/24/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "FrankServer.h"

#import "HTTPServer.h"
#import "RoutingHTTPConnection.h"
#import "StaticResourcesRoute.h"
#import "FrankCommandRoute.h"
#import "DumpCommand.h"
#import "MapOperationCommand.h"
#import "MemoryLogger.h"

void LogToMemory(NSString *format, ...) {
    if (format == nil) {
        return;
    }
    va_list argList;
    va_start(argList, format);
	
    NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
	NSRange range = [s rangeOfString:@"\nClass: "];
	if( range.location != NSNotFound )
	{
		NSString *logline = [s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"];
		printf("MemLog: %s\n", [logline UTF8String]);
		[MemoryLogger log: logline];
		printf("***\nMemory Log Now contains:\n%s\n***\n", [[MemoryLogger getLog] UTF8String]);
	} else {
		NSLogv(format, argList);
	}
	
    [s release];
    va_end(argList);
}

@implementation FrankServer

- (id) initWithDefaultBundle {
	return [self initWithStaticFrankBundleNamed: @"frank_static_resources"];
}

- (id) initWithStaticFrankBundleNamed:(NSString *)bundleName
{
	self = [super init];
	if (self != nil) {
		if( ![bundleName hasSuffix:@".bundle"] )
			bundleName = [bundleName stringByAppendingString:@".bundle"];
		
		
		FrankCommandRoute *frankCommandRoute = [[[FrankCommandRoute alloc] init] autorelease];
		[frankCommandRoute registerCommand:[[[DumpCommand alloc]init]autorelease] withName:@"dump"];
		[frankCommandRoute registerCommand:[[[MapOperationCommand alloc]init]autorelease] withName:@"map"];
		[[RequestRouter singleton] registerRoute:frankCommandRoute];
		
		StaticResourcesRoute *staticRoute = [[[StaticResourcesRoute alloc] initWithStaticResourceSubDir:bundleName] autorelease];
		[[RequestRouter singleton] registerRoute:staticRoute];
		
		_httpServer = [[[HTTPServer alloc]init] retain];
		
		[_httpServer setName:@"Frank UISpec server"];
		[_httpServer setType:@"_http._tcp."];
		[_httpServer setConnectionClass:[RoutingHTTPConnection class]];
		[_httpServer setPort:FRANK_SERVER_PORT];
		NSLog( @"Creating the server: %@", _httpServer );
	}
	return self;
}

- (BOOL) startServer{
	NSError *error;
	if( ![_httpServer start:&error] ) {
		NSLog(@"Error starting HTTP Server:");// %@", error);
		return NO;
	}
	return YES;
}

- (void) dealloc
{
	[_httpServer release];
	[super dealloc];
}

@end
