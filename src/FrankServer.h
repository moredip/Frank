//
//  FrankServer.h
//  Frank
//
//  Created by phodgson on 5/24/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

@class HTTPServer;

#define FRANK_SERVER_PORT 37265

@interface FrankServer : NSObject {
	HTTPServer *_httpServer;
}

- (id) initWithDefaultBundle;
- (id) initWithStaticFrankBundleNamed:(NSString *)bundleName;

- (BOOL) startServer;


@end
