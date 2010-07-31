//
//  Operation.h
//  Frank
//
//  Created by phodgson on 6/27/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import <Foundation/Foundation.h>


@interface Operation : NSObject {
	SEL _selector;
	NSArray *_arguments;
}

- (id) initFromJsonRepresentation:(NSDictionary *)operationDict;

- (BOOL) appliesToObject:(id)target;
- (id) applyToObject:(id)target;

@end
