//
//  DumpCommandRoute.m
//  Frank
//
//  Created by Ondrej Hanslik on 5/15/13.
//
//

#import "DumpCommandRoute.h"
#import "HTTPDataResponse.h"

#import "ViewJSONSerializer.h"
#import "JSON.h"

#if TARGET_OS_IPHONE
#include "UIApplication+FrankAutomation.h"
#else
#include "NSApplication+FrankAutomation.h"
#endif

@implementation DumpCommandRoute {
    NSMutableDictionary *classMapping;
}

#pragma mark - init/dealloc

- (id) init {
    self = [super init];
    if(self) {
        classMapping = [[NSMutableDictionary alloc] init];
        [self loadClassMapping];
    }
    return self;
}

- (void) dealloc {
    [classMapping release];
    [super dealloc];
}

#pragma mark - Mapping

- (void) loadClassMapping {
    NSString *staticResourceBundlePath = [[NSBundle mainBundle] pathForResource: @"frank_static_resources.bundle" ofType: nil];
    NSBundle *staticResourceBundle = [NSBundle bundleWithPath: staticResourceBundlePath];
    
#if TARGET_OS_IPHONE
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"ViewAttributeMapping" warnIfNotFound:YES];
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"UserViewAttributeMapping" warnIfNotFound:NO];
    
    NSLog(@"Done loading view attribute mapping, found %u classes mapped.\nMapping definition:\n%@", classMapping.count, classMapping);
#else
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"ViewAttributeMappingMac" warnIfNotFound:YES];
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"UserViewAttributeMappingMac" warnIfNotFound:NO];
    
    NSLog(@"Done loading view attribute mapping, found %lu classes mapped.\nMapping definition:\n%@", classMapping.count, classMapping);
#endif
}

- (void)loadClassMappingFromBundle:(NSBundle *)bundle plistFile:(NSString *)fileName warnIfNotFound:(BOOL)warn {
    NSString *mappingPath = [bundle pathForResource:fileName ofType:@"plist"];
    
    if ([mappingPath length] == 0) {
        if (warn) {
            NSLog(@"Warning, could NOT find %@.plist in frank_static_resources.bundle", fileName);
        }
        
        return;
    }
    
    // load the plist
    NSLog(@"Loading class mapping definition from %@.plist in frank_static_resources.bundle", fileName);
    
    NSDictionary *mapping = [NSDictionary dictionaryWithContentsOfFile:mappingPath];
    
    // and turn all keys to Class instances and load the attributes for that class
    for (NSString *key in mapping.keyEnumerator) {
        Class clazz = NSClassFromString(key);
        
        if (clazz == nil) {
            NSLog(@"Warning, class %@ could not be resolved, skipping.", key);
            continue;
        }
        
        // abort this class if the value isn't an array
        id attributes = [mapping objectForKey: key];
        
        if (![attributes isKindOfClass: NSArray.class]) {
            NSLog(@"Warning, attribute value for class %@ isn't an array, skipping.", key);
            continue;
        }
        
        [self addAttributeMappings:attributes forClass:clazz];
    }
}

- (void)addAttributeMappings:(NSArray *)attributes forClass:(Class)clazz {
    NSArray *existingAttributes = [classMapping objectForKey:NSStringFromClass(clazz)];
    
    if (existingAttributes) {
        // This class already has a mapping.  Add new attributes to the
        // end of the list.
        NSMutableArray *mergedAttributes = [NSMutableArray arrayWithArray:existingAttributes];
        
        for (NSString *attribute in attributes) {
            if (![existingAttributes containsObject:attribute]) {
                [mergedAttributes addObject:attribute];
            }
        }
        
        attributes = mergedAttributes;
    }
    
    [classMapping setObject:attributes forKey:NSStringFromClass(clazz)];
}

#pragma mark - Serialization

- (NSDictionary *)serializeObject:(NSObject *)object withSubviews:(BOOL)serializeSubviews {
    NSMutableDictionary *serializedObject = [NSMutableDictionary dictionaryWithCapacity:20];
    
    [serializedObject setObject:NSStringFromClass(object.class) forKey: @"class"];
    
    // use the view's raw location in memory as a poor man's uid
    
#if TARGET_OS_IPHONE
    NSString *uid = [NSString stringWithFormat:@"%i", (int) object];
#else
    NSString *uid = [NSString stringWithFormat:@"%lu", (uintptr_t) object];
#endif
    
    [serializedObject setObject:uid forKey:@"uid"];
    
    
    // iterate on all mapping definition classes looking for a (super) class of the current object
    for (NSString *key in classMapping.keyEnumerator) {
        
        Class candidate = NSClassFromString(key);
        
        if (![object isKindOfClass:candidate]) {
            continue;
        }
        
        // now, serialize all defined attributes on the view, if possible
        NSArray *attributes = [classMapping objectForKey:key];
        
        for (NSString *attribute in attributes) {
            // fetch the value for that attribute and add it to the dictionary.
            // note: valueForAttribute is NOT nil safe (i.e. returns nil if value couldn't be extracted
            id value = [self valueForAttribute:attribute onObject:object];
            
            // just skip nil values, we don't want to pollute the JSON tree with bullshitty empty values
            if (value == nil) {
                continue;
            }
            
#if !TARGET_OS_IPHONE
            if ([attribute isEqualToString:@"FEX_accessibilityDescription"]) {
                attribute = @"accessibilityDescription";
            }
            else if ([attribute isEqualToString:@"FEX_accessibilityLabel"]) {
                attribute = @"accessibilityLabel";
            }
            else if ([attribute isEqualToString:@"FEX_accessibilityFrame"]) {
                attribute = @"accessibilityFrame";
            }
#endif
            
            [serializedObject setObject:value forKey:attribute];
        }
    }

    if (serializeSubviews) {
        NSArray *descendants = [self descendantsFromObject:object];
        NSMutableArray *serializedSubviews = [NSMutableArray arrayWithCapacity:descendants.count];
        
        for (NSObject *descendant in descendants) {
            [serializedSubviews addObject:[self serializeObject:descendant withSubviews:YES]];
        }
        
        [serializedObject setObject:serializedSubviews forKey:@"subviews"];
    }
    
    return serializedObject;
}

- (NSArray*)descendantsFromObject:(NSObject *)object {
    // now, recurse on all subviews
#if TARGET_OS_IPHONE
    if ([object isKindOfClass:[UIApplication class]]) {
        return [(UIApplication *) object FEX_windows];
    }
    else if ([object isKindOfClass:[UIView class]]) {
        return [(UIView *) object subviews];
    }

#else
    if ([object isKindOfClass:[NSApplication class]]) {
        NSApplication *application = (NSApplication*) object;
        
        NSMutableArray *descendants = [NSMutableArray array];
        
        [descendants addObjectsFromArray:[application windows]];
        [descendants addObject:[application mainMenu]];
        [descendants addObjectsFromArray:[[application FEX_menus] allObjects]];
        
        return descendants;
    }
    else if ([object isKindOfClass:[NSWindow class]]) {
        return [NSArray arrayWithObject:[(NSWindow*) object contentView]];
    }
    else if ([object isKindOfClass:[NSMenu class]]) {
        return [(NSMenu *) object itemArray];
    }
    else if ([object isKindOfClass:[NSMenuItem class]]) {
        NSMutableArray *descendants = [NSMutableArray array];
        
        NSMenu *submenu = [(NSMenuItem*) object submenu];
        
        if (submenu != nil) {
            [descendants addObject:submenu];
        }
        
        return descendants;
    }
    else if ([object isKindOfClass:[NSView class]]) {
        return [(NSView *) object subviews];
    }
#endif
    
    return [NSArray array];
}

#pragma mark - Extracting an attribute

- (id)valueForAttribute:(NSString *)attribute onObject:(NSObject *)object {
	
	id value;
	
	// Just make sure the input is sane and we're not taking the app down
	@try {
		// Use KVC to get value for attribute, Raises NSUndefinedKeyException if key is not found
		value = [object valueForKey:attribute];
	}
	@catch (NSException *exception) {
		NSLog(@"DumpCommand.m: Warning \"%@\" does not have a value for the key \"%@\".", object.class, attribute);
	}
	@finally {
		// Value can be retrieved via key or selector which are not alway identical,
        // Apple frequently overides getters for booleans an prefaces them with "is"
        
		if (!value) {
			SEL selector = NSSelectorFromString(attribute);
            
			if ([object respondsToSelector:selector]) {
                value = [object performSelector:selector];
			}
			else {
				NSLog(@"DumpCommand.m: Warning \"%@\" does not respond to \"%@\".", object.class, attribute);
				// TODO maybe we could remove that attribute from the classMapping since it doens't respond to selector?
				// if we decide to do, this check will have to move to -serializeObject: since we've lost knowledge of the
				// class mapping defining this attribute
                
				return  nil;
			}
		}
	}
    
    // apply special treatment for special cases: UIColor, UIFont, NSValue, add more as appropriate
#if TARGET_OS_IPHONE
    if ([value isKindOfClass: UIColor.class]) {
        value = [ViewJSONSerializer extractInstanceFromColor:(UIColor *) value];
    }
    
    if ([value isKindOfClass: UIFont.class]) {
        value = [ViewJSONSerializer extractInstanceFromFont:(UIFont *) value];
    }
#else
    if ([value isKindOfClass: NSColor.class]) {
        value = [ViewJSONSerializer extractInstanceFromColor:(NSColor *) value];
    }
    
    if ([value isKindOfClass: NSFont.class]) {
        value = [ViewJSONSerializer extractInstanceFromFont:(NSFont *) value];
    }
#endif
    
    if ([value isKindOfClass: NSValue.class]) {
        value = [ViewJSONSerializer extractInstanceFromValue: (NSValue *) value];
    }
    
    // at this point, we want only NSNumbers, NSArray, NSDictionary, NSString or NSNull,
    if (![value isKindOfClass:NSNumber.class]
        && ![value isKindOfClass:NSString.class]
        && ![value isKindOfClass:NSArray.class]
        && ![value isKindOfClass:NSDictionary.class]
        && ![value isKindOfClass:NSNull.class]
        && value != nil) {
        
        return [NSString stringWithFormat:@"<%@ @%i>", [value class], (int) value];
    }
    
    return value;
}

#pragma mark - Search by UID

- (NSObject*)objectWithUID:(NSString*)uidString {
    void *uid = (void *) [uidString longLongValue];
        
#if TARGET_OS_IPHONE
    NSObject *rootObject = [UIApplication sharedApplication];

#else
    NSObject *rootObject = [NSApplication sharedApplication];
#endif

    NSMutableArray *queue = [NSMutableArray arrayWithObject:rootObject];
    
    while (queue.count > 0) {
        NSObject *next = [queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
        
        if ((void *) next == uid) {
            return next;
        }
        else {
            [queue addObjectsFromArray:[self descendantsFromObject:next]];
        }
    }

    return nil;
}

#pragma mark - Route

- (BOOL)canHandlePostForPath:(NSArray *)path {
    return [@"dump" isEqualToString:[path objectAtIndex:0]];
}

- (NSObject<HTTPResponse> *)handleRequestForPath:(NSArray *)path withConnection:(RoutingHTTPConnection *)connection {
    if (![@"dump" isEqualToString:[path objectAtIndex:0]]) {
        return nil;
    }
    
    NSObject *root = nil;
    BOOL serializeSubviews = YES;
    
    NSString *path2Component = ([path count] >= 2) ? [path objectAtIndex:1] : nil;
    
    if ([path count] >= 3 && [path2Component isEqualToString:@"view"]) {
        NSString *uid = [path objectAtIndex:2];
        root = [self objectWithUID:uid];
        serializeSubviews = NO;
    }
    else if ([path count] >= 3 && [path2Component isEqualToString:@"views"]) {
        NSString *uid = [path objectAtIndex:2];
        root = [self objectWithUID:uid];
    }
    
#if TARGET_OS_IPHONE
    if ([path2Component isEqualToString:@"allwindows"]) {
        root = [UIApplication sharedApplication];
    }
    else if ([path count] == 1) {
        root = [UIApplication sharedApplication].keyWindow;
    }
#else
    if ([path count] == 1) {
        root = [NSApplication sharedApplication];
    }
#endif
    
    if (root == nil) {
        return nil;
    }
    else {
        NSDictionary *serializedRoot = [self serializeObject:root withSubviews:serializeSubviews];
        NSString *json = TO_JSON(serializedRoot);
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        return [[[HTTPDataResponse alloc] initWithData:jsonData] autorelease];
    }
}

@end
