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
#import "ImageCaptureRoute.h"
#import "FrankCommandRoute.h"
#import "DumpCommand.h"
#import "MapOperationCommand.h"
#import "OrientationCommand.h"
#import "LocationCommand.h"
#import "ExitCommand.h"
#import "AppCommand.h"
#import "AccessibilityCheckCommand.h"
#import "KeyboardCommand.h"
#import "EnginesCommand.h"

static NSUInteger __defaultPort = FRANK_SERVER_PORT;
@implementation FrankServer

+ (void)setDefaultHttpPort:(NSUInteger)port
{
    __defaultPort = port;
}
- (id) initWithDefaultBundle {
	return [self initWithStaticFrankBundleNamed: @"frank_static_resources"];
}

- (id) initWithStaticFrankBundleNamed:(NSString *)bundleName
{
	self = [super init];
	if (self != nil) {
		if( ![bundleName hasSuffix:@".bundle"] )
			bundleName = [bundleName stringByAppendingString:@".bundle"];
		
		FrankCommandRoute *frankCommandRoute = [FrankCommandRoute singleton];
		[frankCommandRoute registerCommand:[[[DumpCommand alloc]init]autorelease] withName:@"dump"];
		[frankCommandRoute registerCommand:[[[MapOperationCommand alloc]init]autorelease] withName:@"map"];
		[frankCommandRoute registerCommand:[[[OrientationCommand alloc]init]autorelease] withName:@"orientation"];
        [frankCommandRoute registerCommand:[[[LocationCommand alloc]init]autorelease] withName:@"location"];
		[frankCommandRoute registerCommand:[[[AccessibilityCheckCommand alloc] init]autorelease] withName:@"accessibility_check"];
		[frankCommandRoute registerCommand:[[[AppCommand alloc] init]autorelease] withName:@"app_exec"];
        [frankCommandRoute registerCommand:[[[KeyboardCommand alloc] init]autorelease] withName:@"type_into_keyboard"];
        [frankCommandRoute registerCommand:[[[EnginesCommand alloc] init]autorelease] withName:@"engines"];
        [frankCommandRoute registerCommand:[[[ExitCommand alloc] init] autorelease] withName:@"exit"];
		[[RequestRouter singleton] registerRoute:frankCommandRoute];
		
		StaticResourcesRoute *staticRoute = [[[StaticResourcesRoute alloc] initWithStaticResourceSubDir:bundleName] autorelease];
		[[RequestRouter singleton] registerRoute:staticRoute];
        
        ImageCaptureRoute *imageCaptureCommand = [[[ImageCaptureRoute alloc] init] autorelease];
		[[RequestRouter singleton] registerRoute:imageCaptureCommand];
		
		_httpServer = [[[HTTPServer alloc]init] retain];
		
		[_httpServer setName:@"Frank UISpec server"];
		[_httpServer setType:@"_http._tcp."];
		[_httpServer setConnectionClass:[RoutingHTTPConnection class]];
		[_httpServer setPort:__defaultPort];
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
