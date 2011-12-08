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

- (UIImage *) grabScreenshot:(BOOL)allWindows {	
    
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	
	UIGraphicsBeginImageContext(keyWindow.bounds.size);
    if (allWindows)
    {
        for (UIWindow *w in [[UIApplication sharedApplication] windows])
        {
            [w.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
    }
    else
    {
        [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return image;
}

#pragma mark Route implementation

- (id<FrankCommand>) commandForPath: (NSArray *)path{
	if( 1 != [path count] )
		return nil;
	
	return [_commandDict objectForKey:[path objectAtIndex:0]];
}

- (UIImage *)cropImage:(UIImage *)image toFrame:(CGRect)cropFrame
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropFrame);
    UIImage *result = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    return result;
}


- (NSObject<HTTPResponse> *) handleRequestForPath: (NSArray *)path withConnection:(RoutingHTTPConnection *)connection{
    
	NSLog( @"received request with path %@\nPOST DATA:\n%@", path, connection.postDataAsString );
    
	if( [@"screenshot" isEqualToString:[path objectAtIndex:0]] )
	{
        BOOL allWindows = [path count] > 1;
        UIImage *screenshot = [self grabScreenshot:allWindows];
        
        if ([path count] == 4)
        {
            NSString *stringRepresentation = [path objectAtIndex:3];
            NSArray *parts = [stringRepresentation componentsSeparatedByString:@"."];
            CGRect crop = CGRectZero;
            
            crop.origin.x = [[parts objectAtIndex:0] integerValue];
            crop.origin.y = [[parts objectAtIndex:1] integerValue];
            crop.size.width  = [[parts objectAtIndex:2] integerValue];
            crop.size.height = [[parts objectAtIndex:3] integerValue];
            
            screenshot = [self cropImage:screenshot toFrame:crop];
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
