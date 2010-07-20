//
//  AppDelegate_Phone.m
//  EmployeeAdmin
//
//  Created by phodgson on 6/19/10.
//  Copyright ThoughtWorks 2010. All rights reserved.
//

#import "AppDelegate_Phone.h"
#import "ApplicationFacade.h"
#import "EmployeeAdmin.h"

@implementation AppDelegate_Phone

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	EmployeeAdmin *employeeAdmin = [[[EmployeeAdmin alloc] initWithFrame:[window frame]] autorelease];
	[[ApplicationFacade getInstance] startup:employeeAdmin];
	[window addSubview:employeeAdmin];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
