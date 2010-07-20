//
//  StaticResourcesRoute.h
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestRouter.h"

@interface StaticResourcesRoute : NSObject<Route> {
	NSString *_staticResourceDirectoryPath;
}

- (id) initWithStaticResourceSubDir:(NSString *)resourceSubdir;

@end
