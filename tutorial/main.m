#import <UIKit/UIKit.h>
#ifdef FRANK
#include "FrankServer.h"
static FrankServer *sFrankServer;
#endif

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#ifdef FRANK
	sFrankServer = [[FrankServer alloc] initWithDefaultBundle];
	[sFrankServer startServer];
#endif
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
