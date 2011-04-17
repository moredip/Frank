//
//  FrankCommandRoute.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "FrankCommandRoute.h"
#import "RoutingHTTPConnection.h"

#import <QuartzCore/QuartzCore.h>

@implementation FrankCommandRoute

- (id) init
{
	self = [super init];
	if (self != nil) {
		_commandDict = [[NSMutableDictionary alloc]init];
	}
	return self;
}

- (void) dealloc
{
	[_commandDict release];
	[super dealloc];
}

-(void) registerCommand: (id<FrankCommand>)command withName:(NSString *)commandName {
	[_commandDict setObject:command forKey:commandName];
}

CGImageRef UIGetScreenImage(void); //private API - you should NOT be adding Frank to the target you release to the App Store.

- (NSData *) grabScreenshot {	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	
	UIGraphicsBeginImageContext(keyWindow.bounds.size);
    [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return UIImagePNGRepresentation(image);
}

#pragma mark Route implementation

- (id<FrankCommand>) commandForPath: (NSArray *)path{
	if( 1 != [path count] )
		return nil;
	
	return [_commandDict objectForKey:[path objectAtIndex:0]];
}

- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection{
	
	if( [@"screenshot" isEqualToString:[path objectAtIndex:0]] )
	{
		return [[[HTTPDataResponse alloc] initWithData:[self grabScreenshot]] autorelease];
	}
		
	
	id<FrankCommand> command = [self commandForPath:path];
	if( nil == command )
		return nil;
	
	NSString *response = [command handleCommandWithRequestBody:connection.postDataAsString];
	NSLog( @"returning:\n%@", response );
	
	NSData *browseData = [response dataUsingEncoding:NSUTF8StringEncoding];
	return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
}

- (BOOL) canHandlePostForPath: (NSArray *)path{
	return( nil != [self commandForPath:path] );
}

@end
