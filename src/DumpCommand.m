//
//  DumpCommand.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "objc/runtime.h"

#import "ViewJSONSerializer.h"

#import "DumpCommand.h"

#import "JSON.h"

@interface DumpCommand()
@property (nonatomic, readwrite, retain) NSMutableDictionary *classMapping;

- (NSDictionary *) serializeView: (UIView *) view;
- (id) valueForAttribute: (NSString *) attribute onObject: (NSObject *) object;
- (void) loadClassMapping;
@end

@implementation DumpCommand

- (id) init {
    self = [super init];
    if(self) {        
        // eye ball this guy to about 15 classes.
        self.classMapping = [NSMutableDictionary dictionaryWithCapacity: 15];
        [self loadClassMapping];
    }
    return self;
}

- (void) dealloc {
    self.classMapping = nil;
    [super dealloc];
}

@synthesize classMapping;

- (void) loadClassMapping {
    NSString *staticResourceBundlePath = [[NSBundle mainBundle] pathForResource: @"frank_static_resources.bundle" ofType: nil];
    NSBundle *staticResourceBundle = [NSBundle bundleWithPath: staticResourceBundlePath];

    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"ViewAttributeMapping" warnIfNotFound:YES];
    [self loadClassMappingFromBundle:staticResourceBundle plistFile:@"UserViewAttributeMapping" warnIfNotFound:NO];

    NSLog(@"Done loading view attribute mapping, found %i classes mapped.\nMapping definition:\n%@", classMapping.count, classMapping);
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
    NSArray *existingAttributes = [classMapping objectForKey:clazz] ;
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
    [classMapping setObject:attributes forKey:clazz];
}

#pragma mark - Command handling
- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    // serialize starting from root window and return json representation of it
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	NSDictionary *dom = [self serializeView: window];
    return [dom JSONRepresentation];
}

#pragma mark - view serialization
- (NSDictionary *) serializeView: (UIView *) view {
    NSMutableDictionary *serializedView = [NSMutableDictionary dictionaryWithCapacity: 20];

    [serializedView setObject:NSStringFromClass(view.class) forKey: @"class"];

    // use the view's raw location in memory as a poor man's uid
    [serializedView setObject:[NSNumber numberWithInt:(int)view] forKey:@"uid"];
    
    // iterate on all mapping definition classes looking for a (super) class of the current object
    for(Class candidate in classMapping.keyEnumerator) {
        if(![view isKindOfClass:candidate]) {
            continue;
        }
        
        // now, serialize all defined attributes on the view, if possible
        NSArray *attributes = [classMapping objectForKey: candidate];
        for(NSString *attribute in attributes) {
            // fetch the value for that attribute and add it to the dictionary.
            // note: valueForAttribute is NOT nil safe (i.e. returns nil if value couldn't be extracted
            id value = [self valueForAttribute: attribute onObject: view];
            
            // just skip nil values, we don't want to pollute the JSON tree with bullshitty empty values
            if(value == nil) {
                continue;
            }
            
            [serializedView setObject: value forKey: attribute];
        }
    }
    
    // now, recurse on all subviews
    NSMutableArray *serializedSubviews = [NSMutableArray arrayWithCapacity: view.subviews.count];
    [serializedView setObject: serializedSubviews forKey: @"subviews"];
    
    for(UIView *subview in view.subviews) {
        NSDictionary *serializedSubview = [self serializeView: subview];
        [serializedSubviews addObject: serializedSubview];
    }
    
    return serializedView;
}

#pragma mark - Extracting an attribute
- (id) valueForAttribute: (NSString *) attribute onObject: (NSObject *) object {
    // just make sure the input is sane and we're not taking the app down
    SEL selector = NSSelectorFromString(attribute);
    if(![object respondsToSelector: selector]) {
        NSLog(@"DumpCommand.m: Warning \"%@\" does not respond to \"%@\".", object.class, attribute);
        // TODO maybe we could remove that attribute from the classMapping since it doens't respond to selector?
        // if we decide to do, this check will have to move to -serializeView: since we've lost knowledge of the 
        // class mapping defining this attribute
        return  nil;
    }
    
    // use KVC to get value for attribute
    id value = [object valueForKey: attribute];
    
    // apply special treatment for special cases: UIColor, UIFont, NSValue, add more as appropriate
    if( [value isKindOfClass: UIColor.class]) { 
        value = [ViewJSONSerializer extractInstanceFromColor: (UIColor *) value];
    }
    
    if([value isKindOfClass: UIFont.class]) {
        value = [ViewJSONSerializer extractInstanceFromFont: (UIFont *) value];
    }
    
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
        return [NSString stringWithFormat:@"<%@ @%i>", [value class], value];
    }
    
    return value;
}



@end
