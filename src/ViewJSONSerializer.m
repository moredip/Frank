//
//  ViewJSONSerializer.m
//  Frank
//
//  Created by Olivier Larivain on 2/24/12.
//  Copyright (c) 2012 kra. All rights reserved.
//

#import "ViewJSONSerializer.h"

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
    for(id subObject in (id<NSFastEnumeration>) obj) {
      id subJson = [ViewJSONSerializer jsonify: subObject];
      [array addObject: subJson];
    }
    return array;
  }
  
  if([obj isKindOfClass: NSDictionary.class]) {
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
    
    NSDictionary *theDictionary = (NSDictionary *) obj;
    for(id key in [[theDictionary allKeys] copy]) {
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
  
	if ([obj isKindOfClass: UIColor.class]) {
		return [ViewJSONSerializer extractInstanceFromColor: (UIColor *) obj];
	}
	
	return [NSString stringWithFormat:@"<%@>", NSStringFromClass(obj.class)];
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
