
#include "FrankServer.h"

static FrankServer *sFrankServer;

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	sFrankServer = [[FrankServer alloc] initWithStaticFrankBundleNamed:@"frank_static_resources"];
	NSLog( @"Starting up Frank server on port %i", FRANK_SERVER_PORT );
	[sFrankServer startServer];
	
	int retVal = UIApplicationMain(argc, argv, nil, nil);
	
    [pool release];
    return retVal;
}