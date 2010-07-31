//
//  RoutingHTTPConnection.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "RoutingHTTPConnection.h"

#import "RequestRouter.h"

@interface RoutingHTTPConnection(Private)
- (RequestRouter *)router;
@end

@implementation RoutingHTTPConnection

- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

- (void) dealloc
{
	[_postData release];
	[super dealloc];
}

- (NSString *)postDataAsString{
	if( nil == _postData )
		return nil;
	else
		return [[[NSString alloc] initWithData:(_postData) encoding:NSUTF8StringEncoding] autorelease];
}

#pragma mark HTTPConnection overrides


/**
 * Returns whether or not the server will accept POSTs.
 * That is, whether the server will accept uploaded data for the given URI.
 **/
- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength
{
	return [self.router canHandlePostForPath:path];
}

/**
 * This method is called to handle data read from a POST.
 * The given data is part of the POST body.
 **/
- (void)processPostDataChunk:(NSData *)postDataChunk
{
	if( nil == _postData )
		_postData = [[NSMutableData alloc] init];
	
	[_postData appendData:postDataChunk];
}

/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResopnse is a wrapper for an NSData object, and may be used to send a custom response.
 **/
- (NSObject<HTTPResponse> *)httpResponseForURI:(NSString *)path
{
	NSObject<HTTPResponse> *response = [self.router handleRequestForPath:path withConnection:self];
	
	postContentLength = 0;
	if( nil != _postData )
	{
		[_postData release];
		_postData = nil;
	}
	
	return response;
}

@end

@implementation RoutingHTTPConnection(Private)

- (RequestRouter *)router{
	return [RequestRouter singleton];
}

@end