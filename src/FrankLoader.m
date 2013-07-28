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

#if !TARGET_OS_IPHONE
#import "NSApplication+FrankAutomation.h"
#endif

BOOL frankLogEnabled = NO;

@implementation FrankLoader

+ (void)applicationDidBecomeActive:(NSNotification *)notification{
#if TARGET_OS_IPHONE
    FrankServer *server = [[FrankServer alloc] initWithDefaultBundle];
    [server startServer];
    
#else
    static dispatch_once_t frankDidBecomeActiveToken;
    
    dispatch_once(&frankDidBecomeActiveToken, ^{
        FrankServer *server = [[FrankServer alloc] initWithDefaultBundle];
        [server startServer];
        
        [[NSApplication sharedApplication] FEX_startTrackingMenus];
        
        [[NSNotificationCenter defaultCenter] removeObserver: [self class]
                                                        name: NSApplicationDidUpdateNotification
                                                      object: nil];
    });
#endif
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
    NSString *notificationName = NSApplicationDidUpdateNotification;
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:[self class] 
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:notificationName
                                               object:nil];
}

@end
