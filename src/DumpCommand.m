//
//  DumpCommand.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "objc/runtime.h"

#import "DumpCommand.h"

#import "UIQuery.h"
#import "JSON.h"

static NSArray *skippedClasses;

@interface DumpCommand()
@property (nonatomic, readwrite, retain) NSMutableDictionary *classMapping;

// extracting classes, will end up in a proper static class to avoid weird dependencies
+ (id) extractInstanceFromValue: (NSValue *) value;
+ (id) extractInstanceFromColor: (UIColor *) color;
+ (id) extractInstanceFromFont: (UIFont *) font;

- (NSDictionary *) serializeView: (UIView *) view;
- (id) valueForAttribute: (NSString *) attribute onObject: (NSObject *) object;
- (void) loadClassMapping;
@end

@implementation DumpCommand

- (id) init {
    self = [super init];
    if(self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // so far, the only class I've found that can't properly be serialized
            // Using NSClassFromString to avoid import and pulling all of CoreAnimation
            skippedClasses = [[NSArray alloc] initWithObjects: NSClassFromString(@"CALayer"), 
                                NSClassFromString(@"UIWindowLayer"),
                                NSClassFromString(@"MKMapView"), nil];
        });
        
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
    NSLog(@"Loading class mapping definition from ViewAttributeMapping.plist in frank_static_resources.bundle");
    // find path to the view mapping plist file
    NSString *staticResourceBundlePath = [[NSBundle mainBundle] pathForResource: @"frank_static_resources.bundle" ofType: nil];
    NSBundle *staticResourceBundle = [NSBundle bundleWithPath: staticResourceBundlePath];
    NSString *classMappingPath = [staticResourceBundle pathForResource: @"ViewAttributeMapping" ofType:@"plist"];
    
    // abort early if not found
    if([classMappingPath length] == 0) {
        NSLog(@"Warning, could NOT find ViewAttributeMapping.plist in frank_static_resources.bundle");
        return;
    }
    
    // load the plist
    NSDictionary *theClassMapping = [NSDictionary dictionaryWithContentsOfFile: classMappingPath];
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
        
        [classMapping setObject: attributes forKey: clazz];
    }
    
    NSLog(@"Done loading view attribute mapping, found %i classes mapped.\nMapping definition:\n%@", classMapping.count, classMapping);
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
    // eye ball this array to about 20 views, should be more than enough per view.
    // will avoid resizing the array constantly (and fuck the wasted space).
    NSMutableDictionary *serializedView = [NSMutableDictionary dictionaryWithCapacity: 20];
    
    // start by serializing the view's class string representation
    Class viewClass = view.class;
    
    NSString *className = NSStringFromClass(viewClass);
    [serializedView setObject: className forKey: @"class"];
    
    // iterate on all mapping definition classes looking for a (super) class of the current object
    for(Class candidate in classMapping.keyEnumerator) {
        // no match. Next!
        if(![viewClass isSubclassOfClass: candidate]) {
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
            
            // make sure we're not trying to return a field that should be skipped
            BOOL shouldContinue = NO;
            // we HAVE to go through all classes, -contains: value.class won't work since we could
            // get a subclass and equality will just return NO when we want to skip the value.
            for(Class clazz in skippedClasses) {
                if([value isKindOfClass: clazz]) {
                    shouldContinue = YES;
                    break;
                }
            }
            if (shouldContinue) {
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
        value = [DumpCommand extractInstanceFromColor: (UIColor *) value];
    }
    
    if([value isKindOfClass: UIFont.class]) {
        value = [DumpCommand extractInstanceFromFont: (UIFont *) value];
    }
    
    if([value isKindOfClass: NSValue.class]) {
        value = [DumpCommand extractInstanceFromValue: (NSValue *) value];
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

#pragma mark - Special conversions
#pragma mark UIColor
+ (id) extractInstanceFromColor: (UIColor *) color {
    CGColorSpaceModel colorModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    const CGFloat *colors = CGColorGetComponents(color.CGColor);
    
    id value = nil;
    // so far, only RGB and monochrome color spaces are supported. Adding CMYK and other fancy pants
    // color spaces should be dead simple, just no need for it so far.
    switch (colorModel) {
        case kCGColorSpaceModelRGB:
            value = [NSDictionary dictionaryWithObjectsAndKeys: 
                     [NSNumber numberWithFloat:colors[0]], @"red",
                     [NSNumber numberWithFloat:colors[1]], @"blue",
                     [NSNumber numberWithFloat:colors[2]], @"green",
                     [NSNumber numberWithFloat:colors[3]], @"alpha", 
                     nil];
            break;
        case kCGColorSpaceModelMonochrome:
            value = [NSDictionary dictionaryWithObjectsAndKeys: 
                     [NSNumber numberWithFloat:colors[0]], @"red",
                     [NSNumber numberWithFloat:colors[0]], @"blue",
                     [NSNumber numberWithFloat:colors[0]], @"green",
                     [NSNumber numberWithFloat:colors[1]], @"alpha", 
                     nil];
            break;
        default:
            value = @"<NON-RGB COLOR>";
            break;
    }
        
    return value;
}

+ (id) extractInstanceFromFont: (UIFont *) font {
    if(font == nil) {
        return nil;
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity: 4];
    
    // grab font name, family and size
    [dictionary setObject: font.fontName forKey: @"fontName"];
    [dictionary setObject: font.familyName forKey: @"familyName"];
    NSNumber *pointSize = [NSNumber numberWithFloat: font.pointSize];
    [dictionary setObject: pointSize  forKey: @"pointSize"];
    
    return dictionary;
}

#pragma mark NSValue
+ (id) extractInstanceFromValue:(NSValue *)value {    
    
    const char * objcType = [value objCType];
    if(objcType == NULL) {
        return nil;
    }
    
    // Numbers just passthrough
    if([value isKindOfClass: NSNumber.class]) {
        return value;
    }

    // CG types
    if(strcmp(@encode(CGRect), objcType) == 0) {
        CGRect rawRect;
        [value getValue:&rawRect];
        NSDictionary *originDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:rawRect.origin.x], @"x",
                                    [NSNumber numberWithFloat:rawRect.origin.y], @"y",
                                    nil];
        NSDictionary *sizeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:rawRect.size.width], @"width",
                                  [NSNumber numberWithFloat:rawRect.size.height], @"height",
                                  nil];
        
        return [NSDictionary dictionaryWithObjectsAndKeys:
                originDict, @"origin",
                sizeDict, @"size",
                nil];
    }
    
    if(strcmp(@encode(CGSize), objcType) == 0) {
        CGSize rawSize;
        [value getValue:&rawSize];
        return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithFloat:rawSize.width], @"width",
                [NSNumber numberWithFloat:rawSize.height], @"height",
                nil];
    }
    
    if(strcmp(@encode(CGPoint), objcType) == 0) {
        CGPoint point;
        [value getValue:&point];
        return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithFloat: point.x], @"x",
                [NSNumber numberWithFloat: point.y], @"y",
                nil];
    }

    NSString *typeString = [NSString stringWithFormat:@"%s", objcType]; 
	if([typeString hasPrefix: @"{"]){
        // Extract Class name from the type, format is {ClassName=Blablabla}
		NSString *valueType = [[[typeString substringFromIndex:1] componentsSeparatedByString:@"="] objectAtIndex:0];
		// In the future we could add support for converting any generic type into a dictionary, if it is helpful to do that
		return [NSString stringWithFormat:@"<%@>", valueType];
		
	}
	
    // just return nothing, we can't do much more anyway
	return nil;
}

#pragma mark - generic JSON conversion
+ (NSObject *) jsonify: (id<NSObject>) obj {
	if(obj == nil || obj == [NSNull null]) {
		return [NSNull null];
    }
	

	if([obj isKindOfClass: NSString.class] || 
       [obj isKindOfClass: NSNumber.class]) {
		return obj;
    }

	if( [obj isKindOfClass: NSValue.class] ) {
        return  [DumpCommand extractInstanceFromValue: (NSValue *) obj];
	}
    
	if ([obj isKindOfClass: UIColor.class]) {
		return [DumpCommand extractInstanceFromColor: (UIColor *) obj];
	}
	
	return [NSString stringWithFormat:@"<%@>", NSStringFromClass(obj.class)];
}


@end
