//
//  RoutingHTTPConnection.h
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import <Foundation/Foundation.h>

#import "HTTPConnection.h"

@class RequestRouter;

@interface RoutingHTTPConnection : HTTPConnection {
	NSMutableData *_postData;
}

- (NSString *)postDataAsString;

@end
