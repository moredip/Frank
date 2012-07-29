//
//  RequestRouter.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "RequestRouter.h"

#import "RoutingHTTPConnection.h"

@interface RequestRouter(Private)

- (NSArray *)pathComponentsWithPath:(NSString *)path;

@end

@implementation RequestRouter

#pragma mark singleton implementation

static RequestRouter *s_singleton;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        s_singleton = [[RequestRouter alloc] init];
    }
}

+ (RequestRouter *) singleton{
	return s_singleton;
}

#pragma mark initialization and deallocation

- (id) init
{
	self = [super init];
	if (self != nil) {
		_routes = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[_routes release];
	[super dealloc];
}

#pragma mark member methods

- (void) registerRoute: (id<Route>) route {
	[_routes addObject:route];
}

- (NSObject<HTTPResponse> *) handleRequestForPath:(NSString *)path withConnection:(RoutingHTTPConnection *)connection {
	
	NSArray *pathComponents = [self pathComponentsWithPath:path];	
	__block NSObject<HTTPResponse> *response = nil;
	for (id<Route> route in _routes) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            response = [[route handleRequestForPath:pathComponents withConnection:connection] retain];
        });
        [response autorelease];
        
		if( nil != response )
			break;
	}
	return response;
}

- (BOOL) canHandlePostForPath:(NSString *)path{
	NSArray *pathComponents = [self pathComponentsWithPath:path];	
	for (id<Route> route in _routes) {
		if( [route canHandlePostForPath:pathComponents] )
			return YES;
	}
	return NO;
}

@end

@implementation RequestRouter(Private)

- (NSArray *)pathComponentsWithPath:(NSString *)path{
	// get rid of query params. We have no use for them, at least for now
	path = [[path componentsSeparatedByString:@"?"] objectAtIndex:0];
			
	NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[path pathComponents]];
	[pathComponents removeObject:@"/"]; //handles leading and trailing slashs
	
	//special case treat request for http://foo/ as a request for http://foo/index.html
	if( 0 == [pathComponents count] )
		return [NSArray arrayWithObject:@"index.html"];
	
	return pathComponents;
}

@end

