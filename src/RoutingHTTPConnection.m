//
//  RoutingHTTPConnection.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "RoutingHTTPConnection.h"
#import "HTTPMessage.h"

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
- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    if ([[method uppercaseString] isEqualToString:@"POST"]) {
        return [self.router canHandlePostForPath:path];
    }
    
    // Assume other method is "GET" and is acceptable.
    return YES;
}

/**
 * This method is called to handle data read from a POST.
 * The given data is part of the POST body.
 **/
- (void)processBodyData:(NSData *)postDataChunk
{
    [_postData appendData:postDataChunk];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
    _postData = [[NSMutableData alloc] initWithCapacity:contentLength];
}

/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResopnse is a wrapper for an NSData object, and may be used to send a custom response.
 **/
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	NSObject<HTTPResponse> *response = [self.router handleRequestForPath:path withConnection:self];
	
	requestContentLength = 0;
	if( nil != _postData )
	{
		[_postData release];
		_postData = nil;
	}
	
	return response;
}

/**
 * This method is called immediately prior to sending the response headers (for an error).
 * This method adds standard header fields, and then converts the response to an NSData object.
 **/
- (NSData *)preprocessErrorResponse:(HTTPMessage *)response;
{
    if ([response statusCode] == 404)
    {
        NSString *msg = @"<html><body>Error 404 - Not Found</body></html>";
        NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];

        [response setBody:msgData];

        NSString *contentLengthStr = [NSString stringWithFormat:@"%lu", (unsigned long)[msgData length]];
        [response setHeaderField:@"Content-Length" value:contentLengthStr];
        return [response messageData];
    }else{
        return [super preprocessErrorResponse:response];
    }
}

@end

@implementation RoutingHTTPConnection(Private)

- (RequestRouter *)router{
	return [RequestRouter singleton];
}

@end