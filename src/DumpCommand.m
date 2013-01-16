//
//  DumpCommand.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "objc/runtime.h"

#import "ViewJSONSerializer.h"
#import "JSON.h"

#import "DumpCommand.h"

#if TARGET_OS_IPHONE
#define FrankSerializeViewType UIView
#else
#define FrankSerializeViewType NSObject
#endif

@interface DumpCommand()

- (NSDictionary *) serializeView: (FrankSerializeViewType *) view;
- (id) valueForAttribute: (NSString *) attribute onObject: (NSObject *) object;
- (void) loadClassMapping;
@end

@implementation DumpCommand

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

- (void) loadClassMapping {
    NSString *staticResourceBundlePath = [[NSBundle mainBundle] pathForResource: @"frank_static_resources.bundle" ofType: nil];
    NSBundle *staticResourceBundle = [NSBundle bundleWithPath: staticResourceBundlePath];

#if TARGET_OS_IPHONE
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"ViewAttributeMapping" warnIfNotFound:YES];
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"UserViewAttributeMapping" warnIfNotFound:NO];
    
    NSLog(@"Done loading view attribute mapping, found %i classes mapped.\nMapping definition:\n%@", classMapping.count, classMapping);
#else
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"ViewAttributeMappingMac" warnIfNotFound:YES];
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"UserViewAttributeMappingMac" warnIfNotFound:NO];
    
    NSLog(@"Done loading view attribute mapping, found %lu classes mapped.\nMapping definition:\n%@", classMapping.count, classMapping);
#endif
}

- (void)loadClassMappingFromBundle:(NSBundle *)bundle plistFile:(NSString *)fileName warnIfNotFound:(BOOL)warn {

    NSString *mappingPath = [bundle pathForResource:fileName ofType:@"plist"];
    if([mappingPath length] == 0) {
        if (warn) {
            NSLog(@"Warning, could NOT find %@.plist in frank_static_resources.bundle", fileName);
        }
        return;
    }

    // load the plist
    NSLog(@"Loading class mapping definition from %@.plist in frank_static_resources.bundle", fileName);
    NSDictionary *theClassMapping = [NSDictionary dictionaryWithContentsOfFile: mappingPath];
    // and turn all keys to Class instances and load the attributes for that class
    for(NSString *key in theClassMapping.keyEnumerator) {
        Class clazz = NSClassFromString(key);
        if(clazz == nil) {
            NSLog(@"Warning, class %@ could not be resolved, skipping.", key);
            continue;
        }

        // abort this class if the value isn't an array
        id attributes = [theClassMapping objectForKey: key];
        if(![attributes isKindOfClass: NSArray.class]) {
            NSLog(@"Warning, attribute value for class %@ isn't an array, skipping.", key);
            continue;
        }

        [self addAttributeMappings:attributes forClass:clazz];
    }
}

- (void)addAttributeMappings:(NSArray *)attributes forClass:(Class)clazz{
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

#pragma mark - Command handling
- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
#if TARGET_OS_IPHONE
    // serialize starting from root window and return json representation of it
    UIWindow *root = [UIApplication sharedApplication].keyWindow;
#else
    // OS X apps can have multiple windows, so the application object is the root.
    NSApplication *root = [NSApplication sharedApplication];
#endif
    
	NSDictionary *dom = [self serializeView: root];
    return TO_JSON(dom);
}

#pragma mark - view serialization
- (NSDictionary *) serializeView: (FrankSerializeViewType *) view {
    NSMutableDictionary *serializedView = [NSMutableDictionary dictionaryWithCapacity: 20];

    [serializedView setObject:NSStringFromClass(view.class) forKey: @"class"];

    // use the view's raw location in memory as a poor man's uid
    [serializedView setObject:[NSNumber numberWithInt:(int)view] forKey:@"uid"];
    
    // iterate on all mapping definition classes looking for a (super) class of the current object
    for(NSString *key in classMapping.keyEnumerator) {
        Class candidate = NSClassFromString(key);
        if(![view isKindOfClass:candidate]) {
            continue;
        }
        
        // now, serialize all defined attributes on the view, if possible
        NSArray *attributes = [classMapping objectForKey:key];
        for(NSString *attribute in attributes) {
            // fetch the value for that attribute and add it to the dictionary.
            // note: valueForAttribute is NOT nil safe (i.e. returns nil if value couldn't be extracted
            id value = [self valueForAttribute:attribute onObject:view];
            
            // just skip nil values, we don't want to pollute the JSON tree with bullshitty empty values
            if(value == nil) {
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
            
            [serializedView setObject:value forKey:attribute];
        }
    }
    
    // now, recurse on all subviews
#if TARGET_OS_IPHONE
    NSMutableArray *serializedSubviews = [NSMutableArray arrayWithCapacity: view.subviews.count];
    [serializedView setObject: serializedSubviews forKey: @"subviews"];
    
    for(UIView *subview in view.subviews) {
        NSDictionary *serializedSubview = [self serializeView: subview];
        [serializedSubviews addObject: serializedSubview];
    }
#else
    if ([view isKindOfClass: [NSApplication class]])
    {
        NSMutableArray *serializedSubviews = [NSMutableArray array];
        for (NSWindow* window in [((NSApplication*) view) windows])
        {
            [serializedSubviews addObject: [self serializeView: window]];
        }
        
        [serializedSubviews addObject: [self serializeView: [((NSApplication*) view) mainMenu]]];
        
        [serializedView setObject: serializedSubviews forKey: @"subviews"];
    }
    else if ([view isKindOfClass: [NSWindow class]])
    {
        NSArray *serializedSubview = [NSArray arrayWithObject: [self serializeView: [((NSWindow *) view) contentView]]];
        [serializedView setObject: serializedSubview forKey: @"subviews"];
    }
    else if ([view isKindOfClass: [NSMenu class]])
    {
        NSMutableArray *serializedSubviews = [NSMutableArray array];
        for (NSMenuItem* item in [((NSMenu*) view) itemArray])
        {
            [serializedSubviews addObject: [self serializeView: item]];
        }
        
        [serializedView setObject: serializedSubviews forKey: @"subviews"];
    }
    else if ([view isKindOfClass: [NSMenuItem class]])
    {
        NSMutableArray *serializedSubviews = [NSMutableArray array];
        NSMenu* submenu = [((NSMenuItem*) view) submenu];
        
        if (submenu != nil)
        {
            [serializedSubviews addObject: [self serializeView: submenu]];
        }
        
        [serializedView setObject: serializedSubviews forKey: @"subviews"];
    }
    else
    {
        NSArray* subviews = [((NSView *) view) subviews];
        NSMutableArray *serializedSubviews = [NSMutableArray arrayWithCapacity: [subviews count]];
        
        for (NSView* subview in subviews)
        {
            [serializedSubviews addObject: [self serializeView: subview]];
        }
        
        [serializedView setObject: serializedSubviews forKey: @"subviews"];
    }
#endif
    
    return serializedView;
}

#pragma mark - Extracting an attribute
- (id) valueForAttribute: (NSString *) attribute onObject: (NSObject *) object {
	
	id value;
	
	// Just make sure the input is sane and we're not taking the app down
	@try {
		// Use KVC to get value for attribute, Raises NSUndefinedKeyException if key is not found
		value = [object valueForKey: attribute];
	}
	@catch (NSException *exception) {
		NSLog(@"DumpCommand.m: Warning \"%@\" does not have a value for the key \"%@\".", object.class, attribute);
	}
	@finally {
		// Value can be retrieved via key or selector which are not alway identical, apple frequently overides getters for booleans an prefaces them with is
		if (!value) {
			SEL selector = NSSelectorFromString(attribute);
			if(![object respondsToSelector: selector]) {
				NSLog(@"DumpCommand.m: Warning \"%@\" does not respond to \"%@\".", object.class, attribute);
				// TODO maybe we could remove that attribute from the classMapping since it doens't respond to selector?
				// if we decide to do, this check will have to move to -serializeView: since we've lost knowledge of the
				// class mapping defining this attribute
				return  nil;
			}
			else {
				value = [object performSelector:selector];
			}
		}
	}
    
    // apply special treatment for special cases: UIColor, UIFont, NSValue, add more as appropriate
#if TARGET_OS_IPHONE
    if( [value isKindOfClass: UIColor.class]) { 
        value = [ViewJSONSerializer extractInstanceFromColor: (UIColor *) value];
    }
    
    if([value isKindOfClass: UIFont.class]) {
        value = [ViewJSONSerializer extractInstanceFromFont: (UIFont *) value];
    }
#else
    if( [value isKindOfClass: NSColor.class]) {
        value = [ViewJSONSerializer extractInstanceFromColor: (NSColor *) value];
    }
    
    if([value isKindOfClass: NSFont.class]) {
        value = [ViewJSONSerializer extractInstanceFromFont: (NSFont *) value];
    }
#endif
    
    if([value isKindOfClass: NSValue.class]) {
        value = [ViewJSONSerializer extractInstanceFromValue: (NSValue *) value];
    }
    
    // at this point, we want only NSNumbers, NSArray, NSDictionary, NSString or NSNull,
    if(![value isKindOfClass: NSNumber.class] && 
        ![value isKindOfClass: NSString.class] && 
        ![value isKindOfClass: NSArray.class] &&    
        ![value isKindOfClass: NSDictionary.class] && 
        ![value isKindOfClass: NSNull.class] &&
        value != nil) {
        return [NSString stringWithFormat:@"<%@ @%i>", [value class], (int)value];
    }
    
    return value;
}



@end
