//
//  FrankLoader.m
//  FrankFramework
//
//  Created by Pete Hodgson on 8/12/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "FrankLoader.h"

#import "FrankServer.h"

#import <dlfcn.h>

#import "DDLog.h"
#import "DDTTYLogger.h"

BOOL frankLogEnabled = NO;

@implementation FrankLoader

+ (void)applicationDidBecomeActive:(NSNotification *)notification{
    FrankServer *server = [[FrankServer alloc] initWithDefaultBundle];
    [server startServer];
}

+ (void)load{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    NSLog(@"Injecting Frank loader");
    
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSString *appSupportLocation = @"/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport";
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *simulatorRoot = [environment objectForKey:@"IPHONE_SIMULATOR_ROOT"];
    if (simulatorRoot) {
        appSupportLocation = [simulatorRoot stringByAppendingString:appSupportLocation];
    }
    
    void *appSupportLibrary = dlopen([appSupportLocation fileSystemRepresentation], RTLD_LAZY);
    
    CFStringRef (*copySharedResourcesPreferencesDomainForDomain)(CFStringRef domain) = dlsym(appSupportLibrary, "CPCopySharedResourcesPreferencesDomainForDomain");
    
    if (copySharedResourcesPreferencesDomainForDomain) {
        CFStringRef accessibilityDomain = copySharedResourcesPreferencesDomainForDomain(CFSTR("com.apple.Accessibility"));
        
        if (accessibilityDomain) {
            CFPreferencesSetValue(CFSTR("ApplicationAccessibilityEnabled"), kCFBooleanTrue, accessibilityDomain, kCFPreferencesAnyUser, kCFPreferencesAnyHost);
            CFRelease(accessibilityDomain);
        }
    }
    
    [autoreleasePool drain];
    
#if TARGET_OS_IPHONE
    NSString *notificationName = @"UIApplicationDidBecomeActiveNotification";
#else
    NSString *notificationName = NSApplicationDidFinishLaunchingNotification;
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:notificationName
                                               object:nil];
}

@end
