//
//  ViewJSONSerializer.m
//  Frank
//
//  Created by Olivier Larivain on 2/24/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import "ViewJSONSerializer.h"

#define PSEUDO_INF	@"inf"

@implementation ViewJSONSerializer
#pragma mark - generic JSON conversion
+ (NSObject *) jsonify: (id<NSObject>) obj {
	if(obj == nil || obj == [NSNull null]) {
		return [NSNull null];
	}
	if([obj isKindOfClass: NSString.class] ||
	   [obj isKindOfClass: NSNumber.class]) {
		return obj;
	}
    
	if([obj isKindOfClass: NSArray.class] || [obj isKindOfClass: NSSet.class]) {
		NSMutableArray *array = [NSMutableArray array];
		
		id<NSFastEnumeration> theArray = (id<NSFastEnumeration>) [(NSObject *)obj copy];
		for(id subObject in theArray) {
			id subJson = [ViewJSONSerializer jsonify: subObject];
			[array addObject: subJson];
		}
		return array;
	}
	
	if([obj isKindOfClass: NSDictionary.class]) {
		NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
		
		NSDictionary *theDictionary = [(NSDictionary *) obj copy];
		for(id key in [theDictionary allKeys]) {
			id value = [theDictionary objectForKey: key];
			
			id subJson = [ViewJSONSerializer jsonify: value];
			if(subJson != nil) {
				[jsonDictionary setObject: subJson forKey: key];
			}
		}
		return jsonDictionary;
	}
	
	
	if( [obj isKindOfClass: NSValue.class] ) {
		return  [ViewJSONSerializer extractInstanceFromValue: (NSValue *) obj];
	}
	
#if TARGET_OS_IPHONE
	if ([obj isKindOfClass: UIColor.class]) {
		return [ViewJSONSerializer extractInstanceFromColor: (UIColor *) obj];
	}
#else
    if ([obj isKindOfClass: NSColor.class]) {
		return [ViewJSONSerializer extractInstanceFromColor: (NSColor *) obj];
	}
#endif
	
	return [NSString stringWithFormat:@"<%@>", NSStringFromClass(obj.class)];
}

#pragma mark - Special conversions
#pragma mark UIColor
+ (id) extractInstanceFromColor: (FrankColor *) color {
	CGColorSpaceModel colorModel = CGColorSpaceGetModel(CGColorGetColorSpace([color CGColor]));
	const CGFloat *colors = CGColorGetComponents([color CGColor]);
	
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

+ (id) extractInstanceFromFont: (FrankFont *) font {
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
		if(isinf([(NSNumber*) value doubleValue])) return PSEUDO_INF;
		return value;
	}
	
	// CG types
	NSDictionary * (^convertCGPoint)(CGPoint) = ^(CGPoint point) {
		return [NSDictionary dictionaryWithObjectsAndKeys:
				(isinf(point.x)) ? PSEUDO_INF : [NSNumber numberWithFloat: point.x], @"x",
				(isinf(point.y)) ? PSEUDO_INF : [NSNumber numberWithFloat: point.y], @"y",
				nil];
	};
	
	NSDictionary * (^convertCGSize)(CGSize) = ^(CGSize size) {
		return [NSDictionary dictionaryWithObjectsAndKeys:
				(isinf(size.width)) ? PSEUDO_INF : [NSNumber numberWithFloat:size.width], @"width",
				(isinf(size.height)) ? PSEUDO_INF : [NSNumber numberWithFloat:size.height], @"height",
				nil];
	};
	
	if(strcmp(@encode(CGRect), objcType) == 0) {
#if TARGET_OS_IPHONE
		CGRect rawRect = [value CGRectValue];
#else
        CGRect rawRect = [value rectValue];
#endif
		
		return [NSDictionary dictionaryWithObjectsAndKeys:
				convertCGPoint(rawRect.origin), @"origin",
				convertCGSize(rawRect.size), @"size",
				nil];
	}
	
	
	if(strcmp(@encode(CGSize), objcType) == 0) {
#if TARGET_OS_IPHONE
		CGSize rawSize = [value CGSizeValue];
#else
        CGSize rawSize = [value sizeValue];
#endif
		
		return convertCGSize(rawSize);
	}
	
	if(strcmp(@encode(CGPoint), objcType) == 0) {
#if TARGET_OS_IPHONE
		CGPoint point = [value CGPointValue];
#else
        CGPoint point = [value pointValue];
#endif
		
		return convertCGPoint(point);
	}
	
	NSString *typeString = [NSString stringWithFormat:@"%s", objcType];
    
    if( [typeString isEqualToString:@"f"] ){
        // for some reason we sometimes see NSValues which box a float but which are not NSNumbers. I don't understand why. Re-boxing the value appears to do the trick however.
        float rawValue;
        [value getValue:&rawValue];
        return [NSNumber numberWithFloat:rawValue];
    }else if([typeString hasPrefix: @"{"]){
		// Extract Class name from the type, format is {ClassName=Blablabla}
		NSString *valueType = [[[typeString substringFromIndex:1] componentsSeparatedByString:@"="] objectAtIndex:0];
		// In the future we could add support for converting any generic type into a dictionary, if it is helpful to do that
		return [NSString stringWithFormat:@"<%@>", valueType];
		
	}
	
	// just return nothing, we can't do much more anyway
	return nil;
}
@end
