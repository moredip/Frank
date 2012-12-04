//
//  FrankCommandRoute.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "HTTPDataResponse.h"

#import "FrankCommandRoute.h"
#import "RoutingHTTPConnection.h"

#if TARGET_OS_IPHONE
#import "UIImage+Frank.h"
#else
#import "NSImage+Frank.h"
#endif

extern BOOL frankLogEnabled;

@implementation FrankCommandRoute


#pragma mark singleton implementation

static FrankCommandRoute *s_singleton;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        s_singleton = [[FrankCommandRoute alloc] init];
    }
}

+ (FrankCommandRoute *) singleton{
	return s_singleton;
}

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

#pragma mark Route implementation

- (id<FrankCommand>) commandForPath: (NSArray *)path{
	if( 1 != [path count] )
		return nil;
	
	return [_commandDict objectForKey:[path objectAtIndex:0]];
}


- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection{
    
    if(frankLogEnabled) {
        NSLog( @"received request with path %@\nPOST DATA:\n%@", path, connection.postDataAsString );
    }
    
	id<FrankCommand> command = [self commandForPath:path];
	if( nil == command )
		return nil;
	
	NSString *response = [command handleCommandWithRequestBody:connection.postDataAsString];
    if(frankLogEnabled) {
        NSLog( @"returning:\n%@", response );
    }
	
	NSData *browseData = [response dataUsingEncoding:NSUTF8StringEncoding];
	return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
}

- (BOOL) canHandlePostForPath: (NSArray *)path{
	return( nil != [self commandForPath:path] );
}

@end
