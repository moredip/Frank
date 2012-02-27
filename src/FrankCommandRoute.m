//
//  FrankCommandRoute.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "FrankCommandRoute.h"
#import "RoutingHTTPConnection.h"

#import "UIImage+Frank.h"

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

#pragma mark Route implementation

- (id<FrankCommand>) commandForPath: (NSArray *)path{
	if( 1 != [path count] )
		return nil;
	
	return [_commandDict objectForKey:[path objectAtIndex:0]];
}


- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection{
    
	NSLog( @"received request with path %@\nPOST DATA:\n%@", path, connection.postDataAsString );
    
	if( [@"screenshot" isEqualToString:[path objectAtIndex:0]] )
	{
        BOOL allWindows = [path count] > 1 && [[path objectAtIndex:0] isEqualToString:@"allwindows"];
        UIImage *screenshot = [UIImage imageFromApplication:allWindows];
        
        if ([path count] == 4)
        {
            NSString *stringRepresentation = [path objectAtIndex:3];
            NSArray *parts = [stringRepresentation componentsSeparatedByString:@"."];
            CGRect rect = CGRectZero;
            
            rect.origin.x = [[parts objectAtIndex:0] integerValue];
            rect.origin.y = [[parts objectAtIndex:1] integerValue];
            rect.size.width  = [[parts objectAtIndex:2] integerValue];
            rect.size.height = [[parts objectAtIndex:3] integerValue];
            
            //
            // Crop image or mask out an area (IE: Timestamp)
            //
            if ([[path objectAtIndex:2] isEqualToString:@"frame"])
                screenshot = [screenshot imageCropedToFrame:rect];
            else if ([[path objectAtIndex:2] isEqualToString:@"mask"])
                screenshot = [screenshot imageMaskedAtFrame:rect];
            else
                NSLog(@"Unknown Operation");
        }
        
        NSData *response = UIImagePNGRepresentation(screenshot);
        
		return [[[HTTPDataResponse alloc] initWithData:response] autorelease];
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
