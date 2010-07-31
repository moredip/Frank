//
//  DumpCommand.m
//  Frank
//
//  Created by phodgson on 5/30/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "DumpCommand.h"
#import "UIQuery.h"
#import "JSON.h"

BOOL objectIsPrimitive( id obj )
{
	return( 
		   [obj isKindOfClass:[NSString class]]
		   || [obj isKindOfClass:[NSNumber class]]
		   || [obj isKindOfClass:[NSNull class]]
		   );
		
}

NSMutableDictionary *filterNonprimitiveValuesFrom( NSDictionary *dictionary ) {
	NSMutableDictionary *filteredDictionary = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
	
	for(id key in [dictionary allKeys]) {
		id value = [dictionary valueForKey:key];
		if( objectIsPrimitive( value ) )
			[filteredDictionary setObject:value forKey:key];
		else
			[filteredDictionary setObject:@"COMPLEX TYPE" forKey:key];
	}
	
	return filteredDictionary;
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
		
	
	return customAttributes;
}

NSDictionary *describeView( UIView *view ) {
	NSMutableArray *subviewDescriptions = [NSMutableArray array];
	for (UIView *subview in view.subviews) {
		[subviewDescriptions addObject: describeView(subview) ];
	}
	
	NSMutableDictionary *description = [NSMutableDictionary dictionaryWithDictionary:[UIQuery describe:view]];
	description = filterNonprimitiveValuesFrom(description);
	[description setObject:subviewDescriptions forKey:@"subviews"];
	[description addEntriesFromDictionary:customAttributesFor(view)];
	
	return description;
}

@implementation DumpCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	NSDictionary *dom = describeView( [[UIApplication sharedApplication] keyWindow] );
	return [dom JSONRepresentation];
}

@end
