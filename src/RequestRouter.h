#import <Foundation/Foundation.h>

#import "HTTPResponse.h"

@class RoutingHTTPConnection;

@protocol Route

- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection;
- (BOOL) canHandlePostForPath: (NSArray *)path;

@end



@interface RequestRouter : NSObject {
	NSMutableArray *_routes;
}

+ (RequestRouter *)singleton;

- (void) registerRoute: (id<Route>) route;
- (NSObject<HTTPResponse> *) handleRequestForPath:(NSString *)path withConnection:(RoutingHTTPConnection *)connection;
- (BOOL) canHandlePostForPath:(NSString *)path;

@end
