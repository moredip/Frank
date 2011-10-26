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

NSMutableDictionary *convertViewDescriptionToJson( NSDictionary *dictionary ) {
	NSMutableDictionary *convertedDictionary = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
	for(id key in [dictionary allKeys]) {
		id value = [dictionary valueForKey:key];
		[convertedDictionary setObject:[DumpCommand jsonify:value] forKey:key];
	}
	return convertedDictionary;
}

NSDictionary *customAttributesFor( UIView *view ) {
	NSMutableDictionary *customAttributes = [NSMutableDictionary dictionary];
	
	if( [view respondsToSelector:@selector(accessibilityLabel)] )
	{
		id value = [view accessibilityLabel];
		if( !value )
			value = [NSNull null];
		[customAttributes setObject:value forKey:@"accessibilityLabel"];
	}
	
	[customAttributes setObject:NSStringFromClass([view class]) forKey:@"class"];
	[customAttributes setObject:[NSNumber numberWithFloat:[view alpha]]  forKey:@"alpha"];
	[customAttributes setObject:[NSNumber numberWithBool:[view isOpaque]]  forKey:@"isOpaque"];
	[customAttributes setObject:[NSNumber numberWithBool:[view isHidden]]  forKey:@"isHidden"];
	[customAttributes setObject:[DumpCommand jsonify:[view backgroundColor]] forKey:@"backgroundColor"];
		
	return customAttributes;
}

NSDictionary *mapObjectToPropertiesDictionary( NSObject *object ) {
	// Based on UIQuery#describe from UISpec codebase

	NSMutableDictionary *properties = [NSMutableDictionary dictionary];
	Class clazz = [object class];
	do {
		unsigned i;
		id objValue;
		int intValue;
		long longValue;
		char *charPtrValue; 
		unsigned char charValue;
		short shortValue;
		float floatValue;
		double doubleValue;
		
		uint propertyCount = 0;
		objc_property_t *propertyList = class_copyPropertyList(clazz, &propertyCount);
		//NSLog(@"%@ property count = %d", clazz, propertyCount);
		for (i=0; i<propertyCount; i++) {
			objc_property_t *thisProperty = propertyList + i;
			const char* propertyName = property_getName(*thisProperty);
			const char* propertyAttributes = property_getAttributes(*thisProperty);
			
			NSString *key = [NSString stringWithFormat:@"%s", propertyName];
			NSString *keyAttributes = [NSString stringWithFormat:@"%s", propertyAttributes];
			
			NSArray *attributes = [keyAttributes componentsSeparatedByString:@","];
			if ([[[attributes lastObject] substringToIndex:1] isEqualToString:@"G"]) {
				key = [[attributes lastObject] substringFromIndex:1];
			}
			
			SEL selector = NSSelectorFromString(key);
			if ([object respondsToSelector:selector] && [key characterAtIndex: 0] != '_') {
				NSMethodSignature *sig = [object methodSignatureForSelector:selector];
				//NSLog(@"sig = %@", sig);
				NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
				[invocation setSelector:selector];
				//NSLog(@"invocation selector = %@", NSStringFromSelector([invocation selector]));
				[invocation setTarget:object];
				
				@try {
					[invocation invoke];
				}
				@catch (NSException *exception) {
					NSLog(@"DumpCommand.mapObjectToPropertiesDictionary caught %@: %@", [exception name], [exception reason]);
					continue;
				}
				
				const char* type = [[invocation methodSignature] methodReturnType];
				NSString *returnType = [NSString stringWithFormat:@"%s", type];
				const char* trimmedType = [[returnType substringToIndex:1] cStringUsingEncoding:NSASCIIStringEncoding];

				//NSLog(@"return values - type: %@", returnType);
				
				switch(*trimmedType) {
					case '@':
						[invocation getReturnValue:(void **)&objValue];
						if (objValue == nil) {
							[properties setObject:[NSNull null] forKey:key];
						} else {
							[properties setObject:objValue forKey:key];
						}
						break;
					case 'i':
						[invocation getReturnValue:(void **)&intValue];
						[properties setObject:[NSNumber	numberWithInt:intValue] forKey:key];
						break;
					case 's':
						[invocation getReturnValue:(void **)&shortValue];
						[properties setObject:[NSNumber	numberWithShort:shortValue] forKey:key];
						break;
					case 'd':
						[invocation getReturnValue:(void **)&doubleValue];
						[properties setObject:[NSNumber	numberWithDouble:doubleValue] forKey:key];
						break;
					case 'f':
						[invocation getReturnValue:(void **)&floatValue];
						[properties setObject:[NSNumber	numberWithFloat:floatValue] forKey:key];
						break;
					case 'l':
						[invocation getReturnValue:(void **)&longValue];
						[properties setObject:[NSNumber	numberWithLong:longValue] forKey:key];
						break;
					case '*':
						[invocation getReturnValue:(void **)&charPtrValue];
						[properties setObject:[NSString stringWithFormat:@"%s", charPtrValue] forKey:key];
						break;
					case 'c':
						[invocation getReturnValue:(void **)&charValue];
						
						// if the property is an unsigned char of 0 or 1 then it's almost certainly a BOOL type
						if( charValue < 2 )
							[properties setObject:[NSNumber	numberWithBool:charValue] forKey:key];
						else {
							[properties setObject:[NSNumber	numberWithUnsignedChar:charValue] forKey:key];
						}

						break;
					case '{': {
						unsigned int length = [[invocation methodSignature] methodReturnLength];
						void *buffer = (void *)malloc(length);
						[invocation getReturnValue:buffer];
						NSValue *value = [[[NSValue alloc] initWithBytes:buffer objCType:type] autorelease];
						
						if( CGRectEqualToRect([value CGRectValue],CGRectZero )) {
							NSLog(@"error, no accessibilityFrame");
							UIView *tmpView = (UIView *)object;
							NSLog(@"frame %@, accessabilityFrame %@", NSStringFromCGRect([tmpView frame]), NSStringFromCGRect([tmpView accessibilityFrame]));
							
							value = [NSValue valueWithCGRect: [tmpView frame]];
						}
						[properties setObject:value forKey:key];
						break;
					}
					default: {
						NSLog(@"Unrecognized return type: %@", returnType);
					}
						
				}
			}
		}
	} while ((clazz = class_getSuperclass(clazz)) != nil);
	//NSLog(@"%@ properties: %@", object, [properties debugDescription]);
    return properties;
}

NSDictionary *describeView( UIView *view ) {
	NSMutableArray *subviewDescriptions = [NSMutableArray array];
	for (UIView *subview in view.subviews) {
		[subviewDescriptions addObject: describeView(subview) ];
	}
	
	NSMutableDictionary *description = [NSMutableDictionary dictionaryWithDictionary:mapObjectToPropertiesDictionary(view)];
	description = convertViewDescriptionToJson(description);
	[description setObject:subviewDescriptions forKey:@"subviews"];
	[description addEntriesFromDictionary:customAttributesFor(view)];
	
	return description;
}

NSObject *jsonifyValue(NSValue *val) {
	if( !strcmp([val objCType], @encode(CGFloat)) ) 
	{
		float floatVal;
		[val getValue:&floatVal];
		return [NSNumber numberWithFloat:floatVal];
	}
	
	if( [val objCType][0] == '{' ){ //NSValue type
		NSString *typeString = [NSString stringWithFormat:@"%s", [val objCType]+1]; //we use +1 to skip past the {
		
		NSString *valueType = [[typeString componentsSeparatedByString:@"="] objectAtIndex:0];

		if( [valueType isEqualToString:@"CGSize"] ){
			CGSize rawSize;
			[val getValue:&rawSize];
			return [NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithFloat:rawSize.width], @"width",
					[NSNumber numberWithFloat:rawSize.height], @"height",
					nil];
		}
		
		if( [valueType isEqualToString:@"CGRect"] ){
			CGRect rawRect;
			[val getValue:&rawRect];
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
		
		// In the future we could add support for converting any generic type into a dictionary, if it is helpful to do that
		return [NSString stringWithFormat:@"<%@>", valueType];
		
	}
	
	// we should really manually convert other types of value object, but we haven't had a need so far.
	return @"<UNSUPPORTED VALUE TYPE>";
}

NSObject *jsonifyColor(UIColor *color){
	CGColorSpaceModel colorModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
	const CGFloat *colors = CGColorGetComponents(color.CGColor);
	 
	if( kCGColorSpaceModelRGB == colorModel )
	{
		return [NSDictionary dictionaryWithObjectsAndKeys: 
				[NSNumber numberWithFloat:colors[0]], @"red",
				[NSNumber numberWithFloat:colors[1]], @"blue",
				[NSNumber numberWithFloat:colors[2]], @"green",
				[NSNumber numberWithFloat:colors[3]], @"alpha", 
				nil];
	}else if (kCGColorSpaceModelMonochrome == colorModel) {
		return [NSDictionary dictionaryWithObjectsAndKeys: 
				[NSNumber numberWithFloat:colors[0]], @"red",
				[NSNumber numberWithFloat:colors[0]], @"blue",
				[NSNumber numberWithFloat:colors[0]], @"green",
				[NSNumber numberWithFloat:colors[1]], @"alpha", 
				nil];
	}else {
		return @"<NON-RGB COLOR>";
	}
}

@implementation DumpCommand

+ (NSObject *) jsonify:(id) obj {
	if( nil == obj )
		return [NSNull null];
	
	if( [obj isKindOfClass:[NSNull class]] )
		return obj;
	if( [obj isKindOfClass:[NSString class]] || 
	   [obj isKindOfClass:[NSNumber class]] )
		return obj;
	if( [obj isKindOfClass:[NSValue class]] )
	{
		return jsonifyValue((NSValue *)obj);
	}
	if ([obj isKindOfClass:[UIColor class]]){
		return jsonifyColor((UIColor *)obj);
	}
	
	return [NSString stringWithFormat:@"<%@>", NSStringFromClass([obj class])];
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	NSDictionary *dom = describeView( [[UIApplication sharedApplication] keyWindow] );
	return [dom JSONRepresentation];
}

@end
