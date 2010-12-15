//
//  InspectCommand.m
//  Frank
//
//  Created by Cory Smith on 10-12-11.
//  Copyright 2010 assn dot ca inc. All rights reserved.
//

#import "InspectCommand.h"

#import "UIQuery.h"
#import "JSON.h"

NSDictionary *getCustomAttributesFor( UIView *view ) {
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



@implementation InspectCommand

- (id) init
{
	self = [super init];
	if (self != nil) {
		accessArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSDictionary *)describeView:(UIView *)view {
	id value;
	if([view respondsToSelector:@selector(accessibilityLabel)])
		value = [view accessibilityLabel];
	if( value ) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromClass([view class]),@"class",view.accessibilityLabel,@"label",nil];
		[accessArray addObject:dict];
	}
	NSMutableArray *subviewDescriptions = [NSMutableArray array];
	for (UIView *subview in view.subviews) {
		
		[subviewDescriptions addObject: [self describeView:subview ] ];
	}
	
	NSMutableDictionary *description = [NSMutableDictionary dictionaryWithDictionary:[UIQuery describe:view]];
		//description = filterNonAccessibleElementsFrom(description);
	[description setObject:subviewDescriptions forKey:@"subviews"];
	[description addEntriesFromDictionary:getCustomAttributesFor(view)];
	
	return description;
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	[accessArray removeAllObjects];
	NSDictionary *dom = [self describeView:[[UIApplication sharedApplication] keyWindow]];
	return [accessArray JSONRepresentation];
}

@end