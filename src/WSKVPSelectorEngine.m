
#import "WSKVPSelectorEngine.h"
#import "UIView+LookupHelpers.h"

@implementation WSKVPSelectorEngine

+(void)load{
    WSKVPSelectorEngine *registeredInstance = [[self alloc]init];
    [SelectorEngineRegistry registerSelectorEngine:registeredInstance WithName:@"kvp_lookup"];
    [registeredInstance release];
}

- (NSArray *) selectViewsWithSelector:(NSString *)selector {
    NSLog( @"Using WSKVPSelectorEngine to select views with selector: %@", selector );

    NSArray *paths = [selector componentsSeparatedByString:@"."];
    if ([paths count] < 2)
        return [NSArray array];

    NSString *className = [paths objectAtIndex:0];
    NSString *path = [[paths subarrayWithRange:NSMakeRange(1, [paths count] - 1)] componentsJoinedByString:@"."];

    id result = [NSClassFromString(className) valueForKeyPath:path];
    
    if ([result isKindOfClass:[NSArray class]])
        return result;
    else
        return [NSArray arrayWithObject:result];
}


@end
